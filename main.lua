local sti = require("sti")
local assets = {}

local function loadAsset(name)
    assets[name] = love.graphics.newImage("media/" .. name)
    assets[name]:setFilter("linear", "nearest")
    return assets[name]
end

-- Some arbitrary config
love.physics.setMeter(16)
local boxworld = love.physics.newWorld(0, 64 * love.physics.getMeter(), true)

local window = {
    scale = 1,
    center = 0,
    width = 0,
    height = 0,
}

local player = {
    walk_speed = 10 * love.physics.getMeter(),
    jump_speed = 24 * love.physics.getMeter(),
    jumping = false,
    texture = "horse.png",
    facing = 1,
    current_level = 1,
    init = function(self)
        local img = assets[self.texture]

        self.body = love.physics.newBody(boxworld, 128, 128, "dynamic")
        -- self.shape = love.physics.newRectangleShape(img:getWidth() - 1, img:getHeight() - 1)
        self.shape = love.physics.newCircleShape(img:getWidth() / 2 - 0.1)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)

        self.body:setFixedRotation(true)
        self.body:setMass(1)
    end,
    -- TODO: map-defined spawn point
    spawn = function(self)
        self.body:setX(128)
        self.body:setY(128)
    end,
    draw = function(self)
        local img = assets[self.texture]
        -- Keep player in center except when at map edge
        local x = math.min(self.body:getX(), window.center) - img:getWidth() / 2 + (self.facing == 1 and 0 or img:getWidth())
        love.graphics.draw(img, x, self.body:getY() - img:getHeight() / 2, 0, self.facing, 1)
    end,
}

local world = {
    map = nil,
    foreground = nil,
    colliders = {},
    deathzones = {},
    goals = {},
}

local keybinds = {
    jump = {"up", "w", "space"},
    crouch = {"down", "s", "lshift"},
    left = {"left", "a"},
    right = {"right", "d"},
}

local function controlDown(name)
    if not keybinds[name] then return end

    for _, key in pairs(keybinds[name]) do
        if love.keyboard.isDown(key) then return true end
    end
end

local function currentZones()
    local zones = {}
    for _, c in pairs(player.body:getContacts()) do
        local f1, f2 = c:getFixtures()
        -- Im not sure if fixtures are consistently ordered, so im explicitly getting the other body
        local other = f1:getBody() == player.body and f2:getBody() or f1:getBody()

        -- collisions dont cout as "zones"
        if c:isTouching() and other:getUserData().type ~= "collision" then
            zones[other:getUserData().type] = true
        end
    end
    return zones
end

local function handleMovement()
    local touching = {}

    for _, c in pairs(player.body:getContacts()) do
        local f1, f2 = c:getFixtures()
        local other = f1:getBody() == player.body and f2:getBody() or f1:getBody()

        -- these values are arbitrary
        if other:getUserData().type == "collider" then
            local nx, ny = c:getNormal()
            if ny < -0.6 then touching.bottom = true end
            if ny > 0.6 then touching.top = true end
            if nx < -0.8 then touching.right = true end
            if nx > 0.8 then touching.left = true end
        end
    end

    local x, y = 0, ({player.body:getLinearVelocity()})[2]

    if controlDown("left") and not touching.left then
        x = x - player.walk_speed
        player.facing = -1
    end

    if controlDown("right") and not touching.right then
        x = x + player.walk_speed
        player.facing = 1
    end

    if y < 0 and not player.jumping and not controlDown("jump") then
        -- y = 0
        -- TODO: fix upward hop up slopes
    end

    player.body:setLinearVelocity(x, y)

    if y >= 0 then player.jumping = false end

    if controlDown("jump") and touching.bottom and not player.jumping then
        player.jumping = true
        player.body:setLinearVelocity(x, 0) -- reset current y velocity before jumping
        player.body:applyLinearImpulse(0, -player.jump_speed)
    end
end

local function loadMap(path)
    local map = sti(path)
    for _, layer in pairs(map.layers) do
        if layer.objects then layer.visible = false end
    end

    -- This is a jank hack. I need to draw the player before the foreground, but drawing the player with the map
    -- aligns the player to the pixels, which is bad. So I make a separate map exclusively for the foreground.
    local foreground = sti(path)
    local f_layer = foreground.layers["foreground"]
    foreground.layers = {["foreground"] = f_layer, f_layer}

    return map, foreground
end

-- "colliders" can mean either colliders or zones
local function spawnColliders(from, to, type, isSensor, sx, sy)
    -- Clear out whatever was in the destination since they may be re-used
    for i = 1, #to do
        to[i].fixture:destroy()
        to[i].body:destroy()
        to[i].shape:release()
        to[i] = nil
    end

    for _, object in pairs(world.map.layers[from].objects) do
        local collider = {}

        if object.shape == "rectangle" then
            collider.body = love.physics.newBody(boxworld, object.x + object.width / 2, object.y + object.height / 2)
            collider.shape = love.physics.newRectangleShape(object.width * (sx or 1), object.height * (sy or 1))
        elseif object.shape == "polygon" then
            collider.body = love.physics.newBody(boxworld, object.x, object.y)

            -- Convert {{x=, y=}, {x=, y=}} to (x, y, x, y) and remove offsets
            local verts = {}
            for _, p in ipairs(object.polygon) do table.insert(verts, p.x - object.x) table.insert(verts, p.y - object.y) end
            collider.shape = love.physics.newPolygonShape(unpack(verts))
        end

        if collider.body and collider.shape then
            collider.fixture = love.physics.newFixture(collider.body, collider.shape)
            collider.fixture:setSensor(isSensor == nil and true or isSensor) -- sensors arent physical
            collider.body:setUserData({type = type})
            table.insert(to, collider)
        end
    end
end

local function loadLevel(num)
    world.map, world.foreground = loadMap("media/level_" .. num .. ".lua")

    spawnColliders("collisions", world.colliders, "collider", false)
    spawnColliders("deathzones", world.deathzones, "deathzone", true, 0.8)
    spawnColliders("goals", world.goals, "goal")
end

love.load = function()
    local w, h = love.graphics.getDimensions()
    love.window.setMode(w, h, {resizable = true})
    -- love.window.maximize()

    loadLevel(1)

    loadAsset("horse.png")
    loadAsset("background.png")

    player:init()
end

love.update = function(dtime)
    window.width, window.height = love.graphics.getDimensions()
    window.scale = window.height / 256
    window.center = window.width / 2 / window.scale

    local zones = currentZones()

    if zones.deathzone then
        return player:spawn()
    end

    if zones.goal then
        player.current_level = player.current_level + 1
        loadLevel(player.current_level)
        return player:spawn()
    end

    handleMovement() -- player movement

    boxworld:update(dtime) -- box2d physics

    world.map:update(dtime) -- map animations
    world.foreground:update(dtime)
end

local debugDraw = nil -- forward declaration

love.draw = function()
    love.graphics.scale(window.scale)
    love.graphics.draw(assets["background.png"], 0, 0)

    local params = {-math.max(0, player.body:getX() - window.center), 0, window.scale, window.scale}

    world.map:draw(unpack(params))
    player:draw()
    world.foreground:draw(unpack(params))

    debugDraw()
end

-- debug stuff
local DEBUG = {
    colliders = false,
    deathzones = false,
    goals = false,
    player = false,
}

local drawZones = function(set, color, style)
    for _, zone in pairs(set) do
        love.graphics.setColor(color)

        local verts = {zone.body:getWorldPoints(zone.shape:getPoints())}
        for i = 1, #verts, 2 do verts[i] = verts[i] - math.max(0, player.body:getX() - window.center) end

        love.graphics.polygon(style, verts)
        love.graphics.setColor(1, 1, 1)
    end
end

debugDraw = function()
    if DEBUG.deathzones then drawZones(world.deathzones, {1, 0, 0, 0.5}, "fill") end
    if DEBUG.goals then drawZones(world.goals, {0, 1, 0, 0.5}, "fill") end
    if DEBUG.colliders then drawZones(world.colliders, {1, 1, 1}, "line") end

    if DEBUG.player then
        love.graphics.setColor(0, 1, 0)

        local x, y = math.min(player.body:getX(), window.center), player.body:getY()
        -- local verts = {player.shape:getPoints()}
        -- for i = 1, #verts do verts[i] = verts[i] + (i % 2 == 0 and y or x) end

        -- love.graphics.polygon("line", verts)
        love.graphics.circle("line", x, y, player.shape:getRadius())
        love.graphics.setColor(1, 1, 1)
    end
end