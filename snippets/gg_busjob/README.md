### Inventory Setup

To use **one_inventory** with **GG-BUSJOB**, follow these steps:

1. Navigate to the following directory:

   ```
   gg_busjob/core/bridge/inventory
   ```

2. Place the **one_inventory** bridge file/folder inside the `inventory` directory.

3. Open:

   ```
   gg_busjob/utility.lua
   ```

4. Locate the inventory configuration and set it to:

   ```lua
   inventory = 'one_inventory'
   ```

5. Save the file and restart the resource.

**GG-BUSJOB** will now use **one_inventory** as its inventory system.


script by **ggstudio**: https://www.ggstudio.store/