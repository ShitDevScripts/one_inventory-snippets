-- 1. Variable Export Mapping Near the top of the file, update the variable mapping block to include OneInv.
OXInv, QBInv, PSInv, OneInv, CoreInv, CodeMInv, OrigenInv, TgiannInv, JPRInv =
    Exports.OXInv or "",
    Exports.QBInv or "",
    Exports.PSInv or "",
    Exports.OneInv or "",
    Exports.CoreInv or "",
    Exports.CodeMInv or "",
    Exports.OrigenInv or "",
    Exports.TgiannInv or "",
    Exports.JPRInv or ""
-- 2. Image Processing Loop Find the if isStarted(OXInv) then block where it processes item images, and add this elseif block directly underneath it to handle One Inventory item images.
            elseif isStarted(OneInv) then
                for k, v in pairs(Items) do
                    local tempInfo = exports[OneInv]:GetItemDefinition(k)
                    Items[k].image = k..".png" -- Set default image
                    if tempInfo and tempInfo.image then
                        Items[k].image = tempInfo.image
                    end
                end
