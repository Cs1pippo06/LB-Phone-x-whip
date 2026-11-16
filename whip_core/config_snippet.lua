-- =======================================================================
-- WHIP Framework (whip_core) - LB-Phone Item Definition Snippet
-- Paste this entry inside `Config.Items = { ... }` in `whip_core/config.lua`
-- =======================================================================

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
