if fs.exists("basalt.lua") then
    shell.run("rm basalt.lua")
end
shell.run("wget run https://basalt.madefor.cc/install.lua release basalt-1.6.6.lua")

if fs.exists("colony.lua") then
    shell.run("rm colony.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/colony.lua")

if fs.exists("colony_stats.lua") then
    shell.run("rm colony_stats.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/colony_stats.lua")

if fs.exists("colony_citizens.lua") then
    shell.run("rm colony_citizens.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/colony_citizens.lua")

if fs.exists("colony_requests.lua") then
    shell.run("rm colony_requests.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/colony_requests.lua")

if fs.exists("colony_workorders.lua") then
    shell.run("rm colony_workorders.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/colony_workorders.lua")

if fs.exists("startup.lua") then
    shell.run("rm startup.lua")
end
shell.run("wget https://raw.githubusercontent.com/Damdrara/computercraft_minecolonies/main/startup.lua")

os.reboot();