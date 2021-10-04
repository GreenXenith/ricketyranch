return {
    intro = {
        parts = {
            {
                sheet = "cutscenes/intro-1.png",
                frames = 2,
                width = 256,
                height = 256,
                loop = true,
                timeout = 0,--5,
                duration = 0.5,
            },
            {
                sheet = "cutscenes/intro-2.png",
                frames = 5,
                width = 256,
                height = 256,
                loop = false,
                timeout = 0,--3,
                duration = {0.1, 0.2, 0.2, 0.3, 1},
            },
            {
                sheet = "cutscenes/intro-3.png",
                frames = 3,
                width = 256,
                height = 256,
                loop = false,
                timeout = 0,--3,
                duration = 0.3,
            },
            {
                sheet = "cutscenes/intro-4.png",
                frames = 2,
                width = 256,
                height = 256,
                loop = true,
                timeout = 0,--4,
                duration = 0.1,
            },
            {
                sheet = "cutscenes/intro-5.png",
                frames = 7,
                width = 256,
                height = 256,
                loop = false,
                timeout = 0, ---1,
                duration = {0.25, 0.25, 0.25, 0.25, 0.4, 0.5, 1},
            },
            {
                sheet = "cutscenes/intro-6.png",
                frames = 14,
                width = 256,
                height = 256,
                loop = false,
                timeout = 0, --3,
                duration = 0.1,
            },
            {
                sheet = "cutscenes/intro-7.png",
                frames = 8,
                width = 256,
                height = 256,
                loop = false,
                timeout = 3.5,
                duration = 0.3,
            },
            {
                sheet = "cutscenes/intro-8.png",
                frames = 9,
                width = 256,
                height = 256,
                loop = false,
                timeout = -1,
                duration = {0.8, 0.6, 0.6, 1.5, 2, 2, 2, 2, 3},
            },
        }
    }
}

--[[

scenename = {
    parts = {
        {
            sheet = "animsheet.png",
            frames = 2, -- total frames
            width = 128, -- frame width
            height = 128, -- frame height (defaults to width)
            loop = true, -- whether or not anim repeats
            timeout = -1, -- time in seconds for when to go to next scene. -1 = end of animation
        }
    }
}

]]--
