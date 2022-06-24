-- Globals provided by pdutility.
stds.didiermalenfant_pdutility = {
    globals = {
        enum = {},
        math = {
            -- This will be overidden for the math.lua file but here we don't want
            -- to make the entire 'math' global read-write in other pdutility files.
            read_only = true,
            fields = {
                clamp = {},
                ring = {},
                ring_int = {},
                approach = {},
                infinite_approach = {},
                round = {},
                sign = {},
            }
        },
        pdutility = {
            fields = {
                animation = {
                    fields = {
                        sequence = {
                            fields = {
                                __index = {},
                                super = { 
                                    fields = {
                                        init = {},
                                    }
                                },
                                init = {},
                                update = {},
                                print = {},
                                clear = {},
                                from = {},
                                to = {},
                                set = {},
                                again = {},
                                sleep = {},
                                loop = {},
                                mirror = {},
                                newEasing = {},
                                getEasingByIndex = {},
                                getEasingByTime = {},
                                get = {},
                                getClampedTime = {},
                                start = {},
                                stop = {},
                                pause = {},
                                restart = {},
                                isDone = {},
                                isEmpty = {},
                            }
                        }
                    }
                },
                debug = {
                    read_only = false,
                    fields = {
                        betamax = {
                            read_only = false,
                            fields = {
                                eof = {},
                                printFrame = {},
                            }
                        },                        
                        showToast = {},
                        sampler = {
                            read_only = false,
                            fields = {
                                super = { 
                                    fields = {
                                        init = {},
                                    }
                                },
                                new = {},
                                init = {},
                                reset = {},                                
                                print = {},                                
                                draw = {},
                            }
                        }
                    }
                },
                graphics = {
                    read_only = false,
                    fields = {
                        animatedImage = {
                            read_only = false,
                            fields = {
                                super = { 
                                    read_only = false,
                                    fields = {
                                        init = {},
                                    }
                                },
                                init = {},
                                reset = {},                                
                                setDelay = {},
                                getDelay = {},
                                setShouldLoop = {},
                                getShouldLoop = {},
                                setPaused = {},
                                getPaused = {},
                                setFrame = {},
                                getFrame = {},
                                setFirstFrame = {},
                                setLastFrame = {},
                                __index = {},
                            }                
                        },
                        drawTiledImage = {},
                        drawQuadraticBezier = {},
                        drawCubicBezier = {},
                        getSvgPaths = {},
                        parallax = {
                            fields = {
                                super = { 
                                    fields = {
                                        init = {},
                                    }
                                },        
                                init = {},
                                draw = {},
                                addLayer = {},
                                scroll = {},
                            }
                        },
                    }
                },
                utils = {
                    fields = {
                        signal = {
                            fields = {
                                super = { 
                                    fields = {
                                        init = {},
                                    }
                                },
                                init = {},
                                subscribe = {},
                                unsubscribe = {},
                                notify = {},
                            }
                        },
                        state = {
                            fields = {
                                super = { 
                                    fields = {
                                        init = {},
                                    }
                                },
                                init = {},
                                __newindex = {},
                                __index = {},
                                subscribe = {},
                                unsubscribe = {},
                            }
                        }
                    }
                }
            }
        },
        table = {
            -- This will be overidden for the table.lua file but here we don't want
            -- to make the entire 'table' global read-write in other pdutility files.
            read_only = true,
            fields = {
                random = {},
                each = {},
                newAutotable = {},
            }
        }
    }
}

-- betamax modifies some playdate globals.
stds.didiermalenfant_pdutility_betamax = {
    read_globals = {
        math = {
            fields = {
                randomseed = { read_only = false },
                random = { read_only = false },
            }
        },
        playdate = {
            fields = {
                getCurrentTimeMilliseconds = { read_only = false },
                getTime = { read_only = false },
                getSecondsSinceEpoch = { read_only = false },
                startAccelerometer = { read_only = false },
                stopAccelerometer = { read_only = false },
                getCurrentTimeMilliseconds = { read_only = false },
                getTime = { read_only = false },
                getSecondsSinceEpoch = { read_only = false },
                buttonIsPressed = { read_only = false },
                buttonJustPressed = { read_only = false },
                buttonJustReleased = { read_only = false },
                isCrankDocked = { read_only = false },
                getCrankPosition = { read_only = false },
                getCrankChange = { read_only = false },
                accelerometerIsRunning = { read_only = false },
                readAccelerometer = { read_only = false },
                datastore = {
                    fields = {
                        read = { read_only = false },
                    }
                }
            }
        },
    }
}

-- sequence modifies some playdate globals.
stds.didiermalenfant_pdutility_sequence = {
    read_globals = {
        playdate = {
            fields = {
                easingFunctions = {
                    fields = {
                        flat = { read_only = false },
                    }
                },
            }
        },
    }
}

-- This is only used for the math.lua file
stds.didiermalenfant_pdutility_math = {
    globals = {
        math = {
            fields = {
                clamp = {},
                ring = {},
                ring_int = {},
                approach = {},
                infinite_approach = {},
                round = {},
                sign = {},
            }
        },
    }
}

-- This is only used for the table.lua file
stds.didiermalenfant_pdutility_table = {
    globals = {
        table = {
            fields = {
                random = {},
                each = {},
                newAutotable = {},
            }
        },
    }
}

std = "lua54+playdate+didiermalenfant_pdutility"
files["betamax.lua"].std = "+didiermalenfant_pdutility_betamax"
files["sequence.lua"].std = "+didiermalenfant_pdutility_sequence"
files["math.lua"].std = "+didiermalenfant_pdutility_math"
files["table.lua"].std = "+didiermalenfant_pdutility_table"

operators = {"+=", "-=", "*=", "/="}
