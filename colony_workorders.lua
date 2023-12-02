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
        local labelsNeeded = 1

        if #workOrders > 0 then
            labels[1]:setText("Work Orders: " .. #workOrders)
        else
            labels[1]:setText("There are no work orders at this time.")
        end

        local line = 2
        for k, workOrder in ipairs(workOrders) do

            local resources = colony.getWorkOrderResources(workOrder.id)
            local workOrderLines = 1 + #resources

            labelsNeeded = labelsNeeded + workOrderLines
            while #labels < labelsNeeded do
                table.insert(labels, main:addLabel():setText(""):setPosition(2, #labels + 2))
            end

            labels[line]:setText(workOrder.workOrderType .. " " .. workOrder.buildingName .. " lvl" .. workOrder.targetLevel)

            local idx = 1;
            for i, resource in ipairs(resources) do
                if resource.available > resource.needed then
                    workOrderLines = workOrderLines - 1
                    labelsNeeded = labelsNeeded - 1
                else
                    local needed = resource.needed - resource.available
                    labels[line + idx]:setText(" " .. string.format("%4d", needed) .. "x " .. resource.displayName)
                    idx = idx + 1
                end
            end

            line = line + workOrderLines
        end

        while #labels > labelsNeeded do
            labels[#labels]:remove()
            table.remove(labels)
        end

        sleep(1)
    end
end)()

basalt.autoUpdate()