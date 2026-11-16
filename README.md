# LB-Phone Integration for WHIP Framework (whip_core)

A complete, production-ready custom framework & unique inventory bridge connecting [LB-Phone](https://lbphone.com/) to the [WHIP Framework (`whip_core`)](https://github.com/WHIPFX/whip_core).

---

## 📋 Features

- **Character Lifecycle:** Automatically logs in / fetches phone data on character selection (`whip_core:client:playerLoaded`) and logs out on player disconnect / character swap.
- **Player Death Check:** Prevents opening or interacting with the phone while down or dead (`whip_core:IsPlayerDead()`).
- **Full Banking System Integration:**
  - Real-time bank balance display (`exports.whip_core:GetBalance`).
  - In-phone transfers, deposits, and withdrawals linked directly to character bank accounts (`exports.whip_core:BankSystemDeposit`, `exports.whip_core:BankSystemWithdraw`).
  - Supports offline money transfers.
- **Owned Vehicles App:**
  - Displays owned vehicles with model, license plate, stored state, and garage name (`exports.whip_core:GetVehiclesOf`).
- **Job & Duty Support:**
  - Reads active player job (`exports.whip_core:GetPlayerJob`).
- **Unique Inventory Items:**
  - Supports multi-phone ownership where each physical phone item in the inventory holds its own phone number and device name via item metadata (`lbPhoneNumber`, `lbFormattedNumber`, `lbPhoneName`).
  - Auto-assigns a phone number on first setup.
  - Usable item hook via `exports.whip_core:RegisterUseHandler`.
  - In-game in-hand prop: `lb_phone_prop`.
  - Full inventory item icons included (`phone.webp` and `phone.png`).

---

## 📁 Package Structure

```text
lb-phone-whip-integration/
├── README.md
├── server.cfg.example
│
├── lb-phone/
│   ├── config/
│   │   └── config.lua
│   ├── client/custom/
│   │   ├── frameworks/whip.lua
│   │   └── uniquePhones/whip.lua
│   └── server/custom/
│       ├── frameworks/whip.lua
│       └── uniquePhones/whip.lua
│
└── whip_core/
    ├── config_snippet.lua
    └── html/img/items/
        ├── phone.png
        └── phone.webp
```

---

## 🚀 Installation Guide

### Step 1: Copy `lb-phone` bridge files
Copy the contents of the `lb-phone` folder from this package into your server's `lb-phone` resource folder:
- `client/custom/frameworks/whip.lua`
- `client/custom/uniquePhones/whip.lua`
- `server/custom/frameworks/whip.lua`
- `server/custom/uniquePhones/whip.lua`

### Step 2: Configure `lb-phone/config/config.lua`
In your `lb-phone/config/config.lua`, ensure the following options are set:

```lua
Config.Framework = "whip"
Config.CustomFramework = true

Config.Item = {
    Require = true,          -- Requires an item in inventory to open
    Name = "phone",          -- Item key registered in whip_core
    Unique = true,           -- Each phone item has its own phone number
    Inventory = "whip",      -- Custom inventory handler
}

Open = {
    Bind = "F3",             -- Recommended keybind (F1 is reserved by WHIP radial)
}
```

### Step 3: Register `phone` item in `whip_core/config.lua`
Open `whip_core/config.lua` and add the `phone` item inside `Config.Items`:

```lua
    phone = {
        name       = 'Phone',
        desc       = 'A modern smartphone with a touchscreen.',
        weight     = 0.2,
        type       = 'electronics',
        stack      = false,
        maxStack   = 1,
        usable     = true,
        cooldown   = 0,
        prop       = 'lb_phone_prop',
        image      = '@whip_core/html/img/items/phone.webp',
        metaFields = {
            { key = 'lbFormattedNumber', label = 'Number' },
            { key = 'lbPhoneName', label = 'Device' },
        },
    },
```

### Step 4: Add Phone Inventory Icons
Copy `phone.png` and `phone.webp` from `whip_core/html/img/items/` into your server's:
`resources/[core]/whip_core/html/img/items/`

### Step 5: Update `server.cfg`
Ensure resources are started in the correct order and disable the default WHIP phone:

```cfg
ensure oxmysql
ensure whip_core

# Disable default whip_phone
# ensure whip_phone

# Start LB-Phone prop stream and resource
ensure lb-phoneprop
ensure lb-phone
```

---

## 🛠️ Testing

1. Restart your server or restart the resources:
   ```text
   restart whip_core
   restart lb-phoneprop
   restart lb-phone
   ```
2. Spawn a phone into your inventory using txAdmin console or in-game command:
   ```text
   /whip_giveitem phone 1
   ```
3. Open your inventory, place the phone in your quickbar / accessory slot or double click to use it.
4. Press `F3` (or your configured bind) to open the phone.
