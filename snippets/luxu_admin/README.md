To use **one_inventory** with **luxu_admin**, follow these steps:

1. Navigate to the following directory: `luxu_admin\config\config.json`

2. Look in the config.json for **inventory** change it to this

```
  "inventory": {
    "auto_detect": false,
    "name": "one_inventory",
    "images_url": "https://cfx-nui-one_inventory/web/images/%s.png",
    "_comment_": "If auto_detect is true, the inventory will be detected automatically. If it is false, you need to specify the inventory resource name."
  },
```

3. Goto **luxu_admin\bridge\server\inventory.lua** replace all the code in there

4. Goto **luxu_admin\bridge\server\player.lua** replace all the code in there

5. Goto luxu_admin\bridge\shared\inventory.lua look for local images and replace with this code

```
local images = {
    { name = "tgiann-inventory",   path = "https://cfx-nui-inventory_images/images/%s.png" },
    { name = "jaksam_inventory",   path = "https://cfx-nui-jaksam_inventory/_images/%s.png" },
    { name = "ak47_inventory",     path = "https://cfx-nui-ak47_inventory/web/build/images/%s.png" },
    { name = "ak47_qb_inventory",  path = "https://cfx-nui-ak47_qb_inventory/web/build/images/%s.png" },
    { name = "qs-inventory",       path = "https://cfx-nui-qs-inventory/html/images/%s.png" },
    { name = "core_inventory",     path = "https://cfx-nui-core_inventory/html/img/%s.png" },
    { name = "inventory",          path = "https://cfx-nui-inventory/web/dist/assets/items/%s.png" },
    { name = "one_inventory",      path = "https://cfx-nui-one_inventory/web/images/%s.png" },
    --[[ Standard Inventorys ]]
    { name = "ox_inventory",       path = "https://cfx-nui-ox_inventory/web/images/%s.png" },
    { name = "qb-inventory",       path = "https://cfx-nui-qb-inventory/html/images/%s.png" },
    { name = "esx_addoninventory", path = "https://cfx-nui-esx_addoninventory/web/images/%s.png" },
}
```

4. Save the file and restart the resource.

**luxu_admin** will now use **one_inventory** as its inventory system.

script by **luxu**: https://luxu.gg/