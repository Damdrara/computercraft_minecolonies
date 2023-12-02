local basalt = require("basalt")
local colony = peripheral.find("colonyIntegrator")

if not colony or not colony.getColonyID then
    print("Colony Integrator not found or not within colony")
    return
end

local main = basalt.createFrame()
            :setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})
            :setScrollable()

local labels = {
    main:addLabel():setText(""):setPosition(2, 2):setForeground(colors.gray)
}

basalt.schedule(function()
    while true do

        local workOrders = colony.getWorkOrders()
        local labelsNeeded = 1 + (#workOrders * 1)

        while #labels < labelsNeeded do
            local line = #labels + 2
            table.insert(labels, main:addLabel():setText(""):setPosition(2, line))
        end

        while #labels > labelsNeeded do
            labels[#labels]:remove()
            table.remove(labels)
        end

        if #workOrders > 0 then
            labels[1]:setText("Work Orders: " .. #workOrders)
        else
            labels[1]:setText("There are no work orders at this time.")
        end

        local line = 2
        for k, v in ipairs(workOrders) do
            labels[line]
                :setText(v.workOrderType .. ", " .. v.buildingName .. " lvl" .. v.targetLevel)

            line = line + 1
        end
        sleep(1)
    end
end)()

basalt.autoUpdate()