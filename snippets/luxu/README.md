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

4. Goto **luxu_admin\bridge\server\player.lua** replace the function player:canCarryItem with the code in the `bridge\server\player.lua`

5. Goto luxu_admin\bridge\shared\inventory.lua look for local images and replace with the code in `bridge\shared\inventory.lua`

4. Save the file and restart the resource.

**luxu_admin** will now use **one_inventory** as its inventory system.

script by **luxu**: https://luxu.gg/