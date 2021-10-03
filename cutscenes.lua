return {
    test = {
        parts = {
            {
                sheet = "cutscene.png",
                frames = 4,
                width = 128,
                height = 128,
                loop = false,
                timeout = -1,
                duration = 0.2,
            },
            {
                sheet = "cutscene2.png",
                frames = 4,
                width = 128,
                height = 128,
                loop = false,
                timeout = 2,
                duration = 0.5,
            }
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
