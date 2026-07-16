To use **one_inventory** with **lb-phone**, follow these steps:

1. Navigate to the following directory: `lb-phone\client\custom\uniquePhones`

2. Add the **one_inventory** client file in the folder.

3. Navigate to the following directory: `lb-phone\server\custom\uniquePhones`

4. Add the **one_inventory** server file in the folder.

5. Navigate to the following directory: `lb-phone\client\custom\frameworks`

6. replace all the files in there with the files we provide

7. Navigate to the following directory: `lb-phone\server\custom\frameworks`

8. replace all the files in there with the files we provide

9. Go to the config and look for **Config.Item.Inventory**. Make that **one_inventory**: `Config.Item.Inventory = "one_inventory"`

10. make sure the Config.Item.Require is set to true

11. Save the file and restart the resource.

**lb-phone** will now use **one_inventory** as its inventory system.

script by **lbscripts**: https://lbscripts.com/