local dlg  = Dialog();
dlg:entry{ id = "columns", label = "Columns:", text = "0", focus = true }
dlg:entry{ id = "rows", label = "Rows:", text = "0" }
dlg:button{ id = "confirm", text = "Confirm", focus = true }
dlg:button{ id = "cancel", text = "Cancel" }
dlg:show()

local data = dlg.data

if data.confirm then
    app.transaction(
        function()
            local cols = tonumber(data.columns)
            local rows = tonumber(data.rows)

            if cols < 2 and rows < 2 then return end

            local sprite = app.activeSprite
            local frameCount = cols * rows
            local frameWidth = sprite.width / cols
            local frameHeight = sprite.height / rows

            for i = 1, frameCount - 1 do
                local newFrame = sprite:newFrame(1)
            end
            
            app.command.GotoFirstFrame()
            
            for i, cel in ipairs(sprite.cels) do
                local img = cel.image
                local x = -frameWidth * ((i - 1) % cols)
                local y = -frameHeight * math.floor((i - 1) / cols)
                img:drawImage(img, Point(x, y))
                sprite.selection = Selection(0, 0, frameWidth, frameHeight)
                app.command.InvertMask()
                app.command.Clear()
                app.command.DeselectMask()
                app.command.GotoNextFrame()
            end

            app.command.AutocropSprite()
        end
    )
end