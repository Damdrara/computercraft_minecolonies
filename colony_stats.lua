local basalt = require("basalt")
local colony = peripheral.find("colonyIntegrator")

if not colony or not colony.getColonyID then
    print("Colony Integrator not found or not within colony")
    return
end

local main = basalt.createFrame()
    :setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})

local lines = {
    main:addLabel():setText(colony.getColonyName()):setPosition(2, 2),
    main:addLabel():setText(""):setPosition(2, 4),
    main:addLabel():setText(""):setPosition(2, 5),
    main:addLabel():setText(""):setPosition(2, 6),
    main:addLabel():setText(""):setPosition(2, 7),
    main:addLabel():setText("COLONY IS UNDER ATTACK!"):setPosition(2, 9):setForeground(colors.red):hide(),
}

basalt.schedule(function()
    while true do
        lines[2]:setText("Citizens:           " .. colony.amountOfCitizens())
        lines[3]:setText("Building Sites:     " .. colony.amountOfConstructionSites())
        lines[4]:setText("Overall happiness:  " .. math.floor(colony.getHappiness()*10)/10)
        lines[5]:setText("Amount of graves:   " .. colony.amountOfGraves())

        if colony.isUnderAttack() then
            lines[6]:show()
        else
            lines[6]:hide()
        end

        sleep(1)
    end
end)()

basalt.autoUpdate()