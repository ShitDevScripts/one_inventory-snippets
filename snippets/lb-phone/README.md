### Inventory Setup

To use **one_inventory** with **lb-phone**, follow these steps:

1. Navigate to the following directory:

   ```
   lb-phone\client\custom\uniquePhones
   ```

2. add tthe **one_inventory** client file in the folder

3. Navigate to the following directory:

   ```
   lb-phone\server\custom\uniquePhones
   ```

4. add tthe **one_inventory** server file in the folder

go to the config and look for **Config.Item.Inventory** make that **one_inventory** 

```
Config.Item.Inventory = "one_inventory"
```

5. Save the file and restart the resource.

**lb-phone** will now use **one_inventory** as its inventory system.




script by **lbscripts**: https://lbscripts.com/
