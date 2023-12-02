shell.openTab("colony")

-- if you want to use cloudcatcher and have this script automatically connect,
-- make a file called cloudconnect.lua with this line in it:
--    shell.run("cloud.lua <token>")
-- and replace the <token> with your cloudcatcher token
-- see https://cloud-catcher.squiddev.cc for more info

if fs.exists("cloudconnect.lua") then
    shell.run("cloudconnect")
end