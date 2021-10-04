return {
    blank = {parts={}},
    intro = {
        parts = {
            {
                sheet = "cutscenes/intro-1.png",
                frames = 2,
                width = 256,
                height = 256,
                loop = true,
                timeout = 5,
                duration = 0.5,
            },
            {
                sheet = "cutscenes/intro-2.png",
                frames = 5,
                width = 256,
                height = 256,
                loop = false,
                timeout = 3,
                duration = {0.1, 0.2, 0.2, 0.3, 1},
            },
            {
                sheet = "cutscenes/intro-3.png",
                frames = 3,
                width = 256,
                height = 256,
                loop = false,
                timeout = 3,
                duration = 0.3,
            },
            {
                sheet = "cutscenes/intro-4.png",
                frames = 2,
                width = 256,
                height = 256,
                loop = true,
                timeout = 4,
                duration = 0.1,
            },
            {
                sheet = "cutscenes/intro-5.png",
                frames = 7,
                width = 256,
                height = 256,
                loop = false,
                timeout = -1,
                duration = {0.25, 0.25, 0.25, 0.25, 0.4, 0.5, 1},
            },
            {
                sheet = "cutscenes/intro-6.png",
                frames = 14,
                width = 256,
                height = 256,
                loop = false,
                timeout = 3,
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
    },
    level_1 = {
        parts = {
            {
                sheet = "cutscenes/1-1.png",
                frames = 23,
                width = 256,
                height = 256,
                loop = false,
                timeout = -1,
                duration = {
                    2, 1.5,
                    0.7 / 7, 0.7 / 7, 0.7 / 7, 0.7 / 7, 0.7 / 7, 0.7 / 7, 1.5,
                    1, 2 / 3, 1,
                    2, 1 / 9, 1 / 9, 1 / 9, 1 / 9, 1 / 9, 1 / 9, 1 / 9, 1 / 9, 1 / 9,
                    3,
                },
            },
        }
    },
    level_2 = {
        parts = {
            {
                sheet = "cutscenes/2-1.png",
                frames = 11,
                width = 256,
                height = 256,
                loop = false,
                timeout = -1,
                duration = {
                    2, 2,
                    1.5, 1.5, 1.5,
                    2, 1.5 / 4, 1.5 / 4, 1.5 / 4, 1.5 / 4,
                    3,
                },
            },
        }
    },
    level_3 = {
        parts = {
            {
                sheet = "cutscenes/3-1.png",
                frames = 2,
                width = 256,
                height = 256,
                loop = true,
                timeout = 3,
                duration = 1 / 6,
            },
            {
                sheet = "cutscenes/3-2.png",
                frames = 7,
                width = 256,
                height = 256,
                loop = false,
                timeout = -1,
                duration = {
                    2, 2,
                    1 / 4, 1 / 4, 1 / 4, 2,
                    8,
                },
            },
        }
    },
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
