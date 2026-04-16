#include "../../include/debug.h"
#include "../../include/pokemon.h"
#include "../../include/save.h"
#include "../../include/script.h"
#include "../../include/types.h"
#include "../../include/constants/item.h"

#ifdef MART_EXPANSION

struct MartItem {
    u16 item_id;
    u16 override_cost;
};

struct BadgeMartItems {
    u16 item_id;
    u8 required_badges;
};

// note: limited to 203 items (~34 pages)
const struct BadgeMartItems sBadgeMart[] = {
    { ITEM_POKE_BALL,      0 },
    { ITEM_GREAT_BALL,     3 },
    { ITEM_ULTRA_BALL,     5 },
    { ITEM_POTION,         0 },
    { ITEM_SUPER_POTION,   1 },
    { ITEM_HYPER_POTION,   5 },
    { ITEM_MAX_POTION,     7 },
    { ITEM_FULL_RESTORE,   8 },
    { ITEM_RARE_CANDY,     5 },
    { ITEM_ANTIDOTE,       0 },
    { ITEM_PARALYZE_HEAL,  0 },
    { ITEM_AWAKENING,      1 },
    { ITEM_BURN_HEAL,      1 },
    { ITEM_ICE_HEAL,       1 },
    { ITEM_FULL_HEAL,      5 },
    { ITEM_ESCAPE_ROPE,    1 },
    { ITEM_REPEL,          1 },
    { ITEM_SUPER_REPEL,    3 },
    { ITEM_MAX_REPEL,      5 },
};

void LONG_CALL InitMartUI(void *taskManager, FieldSystem *fieldSystem, const u16 *items, int kind, int buySell, int decoWhich, const struct MartItem *priceOverrides);

u16 sCherrygroveCityMart[] = {
    ITEM_SHINY_CHARM, ITEM_QUICK_BALL, 0xFFFF
};

u16 sVioletCityMart[] = {
    ITEM_MALICIOUS_ARMOR, ITEM_DIVE_BALL, ITEM_NET_BALL, 0xFFFF
};

u16 sAzaleaCityMart[] = {
    ITEM_AUSPICIOUS_ARMOR, ITEM_NEST_BALL, ITEM_REPEAT_BALL, 0xFFFF
};

u16 sGoldenrodDepartmentUpper2F[] = {
    ITEM_DAWN_STONE, ITEM_DUSK_STONE, ITEM_FIRE_STONE, ITEM_ICE_STONE, ITEM_LEAF_STONE,
    ITEM_MOON_STONE, ITEM_OVAL_STONE, ITEM_SHINY_STONE, ITEM_THUNDER_STONE, ITEM_WATER_STONE,
    ITEM_AMPHAROSITE, 0xFFFF
};

u16 sGoldenrodDepartmentLower2F[] = {
    ITEM_POKE_BALL, ITEM_GREAT_BALL, ITEM_ULTRA_BALL, ITEM_QUICK_BALL, ITEM_FAST_BALL,
    ITEM_LEVEL_BALL, ITEM_LURE_BALL, ITEM_HEAVY_BALL, ITEM_LOVE_BALL, ITEM_FRIEND_BALL,
    ITEM_MOON_BALL, ITEM_BEAST_BALL, 0xFFFF
};

u16 sGoldenrodDepartment3F[] = {
    ITEM_X_SPEED, ITEM_X_ATTACK, ITEM_X_DEFENSE, ITEM_GUARD_SPEC, ITEM_DIRE_HIT,
    ITEM_X_ACCURACY, ITEM_X_SP_ATK, ITEM_X_SP_DEF, 0xFFFF
};

u16 sGoldenrodDepartment4F[] = {
    ITEM_PROTEIN, ITEM_IRON, ITEM_CALCIUM, ITEM_ZINC, ITEM_CARBOS,
    ITEM_HP_UP, 0xFFFF
};

u16 sGoldenrodDepartment5F[] = {//do not change
    ITEM_TM070, ITEM_TM017, ITEM_TM054, ITEM_TM083, ITEM_TM016,
    ITEM_TM033, ITEM_TM022, ITEM_TM052, ITEM_TM038, ITEM_TM025,
    ITEM_TM014, ITEM_TM015, 0xFFFF
};

u16 sGoldenrodHerbs[] = {
    ITEM_HEAL_POWDER, ITEM_ENERGY_POWDER, ITEM_ENERGY_ROOT, ITEM_REVIVAL_HERB, 0xFFFF
};

u16 sEcruteakMart[] = {
    ITEM_TM093, ITEM_TIMER_BALL, ITEM_LUXURY_BALL, 0xFFFF
};

u16 sOlivineMart[] = {
    ITEM_TM094, ITEM_DUSK_BALL, ITEM_HEAL_BALL, 0xFFFF
};

u16 sCianwoodPharmacy[] = {//done
    ITEM_MENTAL_HERB, ITEM_WHITE_HERB, ITEM_REVIVAL_HERB, ITEM_MIRROR_HERB, ITEM_ENERGY_ROOT,
    0xFFFF
};

u16 sBlackthornAndBattleFrontierMart[] = {//done
    ITEM_TM095, ITEM_NET_BALL, ITEM_DUSK_BALL, 0xFFFF
};

u16 sIndigoPlateau[] = {//done
    ITEM_ULTRA_BALL, ITEM_MAX_REPEL, ITEM_HYPER_POTION, ITEM_MAX_POTION, ITEM_FULL_RESTORE,
    ITEM_TM036, ITEM_FULL_HEAL, 0xFFFF
};

u16 sVermilionAndSafariMart[] = {
    ITEM_KINGS_ROCK, ITEM_NEST_BALL, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

u16 sSaffronMart[] = {
    ITEM_DEEP_SEA_TOOTH, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

u16 sLavenderMart[] = {
    ITEM_REAPER_CLOTH, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

u16 sCeruleanMart[] = {//done
    ITEM_DEEP_SEA_SCALE, ITEM_QUICK_BALL, 0xFFFF
};

u16 sCeladonDepartmentUpper2F[] = {//done
    ITEM_METAL_COAT, ITEM_UP_GRADE, ITEM_PROTECTOR, ITEM_ELECTIRIZER, ITEM_MAGMARIZER,
    ITEM_DUBIOUS_DISC, ITEM_PRISM_SCALE, ITEM_GALARICA_CUFF, ITEM_LINKING_CORD, ITEM_CRACKED_POT,
    ITEM_CHIPPED_POT, 0xFFFF
};

u16 sCeladonDepartmentLower2F[] = {//done
    ITEM_PEAT_BLOCK, ITEM_METAL_ALLOY, ITEM_SACHET, ITEM_WHIPPED_CREAM, ITEM_RIBBON_SWEET,
    ITEM_STAR_SWEET, ITEM_FLOWER_SWEET, ITEM_CLOVER_SWEET, ITEM_BERRY_SWEET, ITEM_LOVE_SWEET,
    ITEM_STRAWBERRY_SWEET, ITEM_DREAM_BALL, 0xFFFF
};

u16 sCeladonDepartment3F[] = {//do not change
    ITEM_TM021, ITEM_TM027, ITEM_TM087, ITEM_TM078, ITEM_TM012,
    ITEM_TM041, ITEM_TM020, ITEM_TM028, ITEM_TM076, ITEM_TM055,
    ITEM_TM072, ITEM_TM079, 0xFFFF
};

u16 sCeladonDepartment4F[] = {
    ITEM_MAX_REVIVE, ITEM_GARDEVOIRITE, ITEM_KANGASKHANITE, 0xFFFF
};

u16 sCeladonDepartmentLeft5F[] = {
    ITEM_CHERI_BERRY, ITEM_CHESTO_BERRY, ITEM_PECHA_BERRY, ITEM_RAWST_BERRY, ITEM_ASPEAR_BERRY,
    ITEM_LEPPA_BERRY, ITEM_ORAN_BERRY, ITEM_BLACK_AUGURITE, 0xFFFF
};

u16 sCeladonDepartmentRight5F[] = {
    ITEM_VENUSAURITE, ITEM_CHARIZARDITE_X, ITEM_CHARIZARDITE_Y, ITEM_BLASTOISINITE, ITEM_MEDICHAMITE,
    ITEM_BLAZIKENITE, 0xFFFF
};

u16 sFuschiaMart[] = {
    ITEM_DRAGON_SCALE, ITEM_DUSK_BALL, ITEM_QUICK_BALL, 0xFFFF
};

u16 sPewterMart[] = {
    ITEM_AERODACTYLITE, ITEM_NEST_BALL, ITEM_QUICK_BALL, 0xFFFF
};

u16 sViridianMart[] = {
    ITEM_LUCARIONITE, ITEM_NET_BALL, ITEM_HEAL_BALL, 0xFFFF
};

u16 sMtMoonSquare[] = {
    ITEM_MOON_STONE, ITEM_FRESH_WATER, ITEM_SODA_POP, ITEM_LEMONADE, ITEM_BANETTITE,
    ITEM_HOUNDOOMINITE, 0xFFFF
};

u16 sMahoganyPreRocketHideout[] = {
    ITEM_MEWTWONITE_Y, ITEM_UNREMARKABLE_TEACUP, ITEM_POTION, 0xFFFF
};

u16 sMahoganyPostRocketHideout[] = {
    ITEM_GREAT_BALL, ITEM_SUPER_POTION, ITEM_HYPER_POTION, ITEM_CELL_BATTERY, ITEM_UNREMARKABLE_TEACUP,
    ITEM_MASTERPIECE_TEACUP, ITEM_MEWTWONITE_Y, ITEM_MEWTWONITE_X, 0xFFFF
};

BOOL ScrCmd_MartBuy(SCRIPTCONTEXT *ctx) {
    u16 unused UNUSED = ScriptGetVar(ctx);
    
    u16 items[NELEMS(sBadgeMart) + 1];
    u8 badgeCount = 0;
    u8 index = 0;
    u32 i;

    for (i = 0; i < 16; i++) {
        if (PlayerProfile_TestBadgeFlag(Sav2_PlayerData_GetProfileAddr(ctx->fsys->savedata), i) == TRUE) {
            badgeCount++;
        }
    }

    for (i = 0; i < NELEMS(sBadgeMart); i++) {
        if (badgeCount >= sBadgeMart[i].required_badges) {
            items[index] = sBadgeMart[i].item_id;
            index++;
        }
    }

    items[index] = 0xFFFF;
    InitMartUI(ctx->taskman, ctx->fsys, items, 0, 0, 0, 0); // this doesn't honor price overrides
    return TRUE;
}

#endif // MART_EXPANSION

#ifdef POKEATHLON_SHOP_EXPANSION

const struct MartItem sPokeathlonShopSunday[] = {
    { ITEM_RED_APRICORN,   200  },
    { ITEM_BLUE_APRICORN,  200  },
    { ITEM_BLACK_APRICORN, 200  },
    { ITEM_MOOMOO_MILK,    100  },
    { ITEM_KINGS_ROCK,     3000 },
    { ITEM_FOCUS_SASH,    1000 },
    { ITEM_ZOOM_LENS,   500  },
    { ITEM_BLACK_SLUDGE,         500  },
    { ITEM_ICY_ROCK,      3000 },
    { ITEM_DESTINY_KNOT,     2500 },
    { ITEM_METRONOME,    3000 },
    { ITEM_CHOICE_SCARF,     3000 },
    { 0xFFFF,              0    },
};

const struct MartItem sPokeathlonShopMonday[] = {
    { ITEM_RED_APRICORN,   200  },
    { ITEM_BLUE_APRICORN,  200  },
    { ITEM_GREEN_APRICORN, 200  },
    { ITEM_WIDE_LENS,    100  },
    { ITEM_CHARCOAL,     3000 },
    { ITEM_RARE_CANDY,     2000 },
    { ITEM_SHELL_BELL,   1500  },
    { ITEM_UP_GRADE,     3000 },
    { ITEM_SILK_SCARF,      3000 },
    { ITEM_STICKY_BARB,    2500 },
    { ITEM_LUCKY_PUNCH,    3000 },
    { ITEM_DRAGON_FANG,     3000 },
    { 0xFFFF,              0    },
};

const struct MartItem sPokeathlonShopTuesday[] = {
    { ITEM_YELLOW_APRICORN, 200  },
    { ITEM_PINK_APRICORN,   200  },
    { ITEM_WHITE_APRICORN,  200  },
    { ITEM_BLACK_GLASSES,   100  },
    { ITEM_TWISTED_SPOON,   2500 },
    { ITEM_SPELL_TAG,       1000 },
    { ITEM_BLACK_BELT,      500  },
    { ITEM_MAGNET,          2500 },
    { ITEM_NEVER_MELT_ICE,  2500 },
    { ITEM_POISON_BARB,     2500 },
    { ITEM_SHARP_BEAK,      3000 },
    { ITEM_MYSTIC_WATER,    3000 },
    { 0xFFFF,               0    },
};

const struct MartItem sPokeathlonShopWednesday[] = {
    { ITEM_BLUE_APRICORN,  200  },
    { ITEM_PINK_APRICORN,  200  },
    { ITEM_BLACK_APRICORN, 200  },
    { ITEM_MOOMOO_MILK,    100  },
    { ITEM_SWEET_APPLE,    2500 },
    { ITEM_TART_APPLE,     2000 },
    { ITEM_LEFTOVERS,   500  },
    { ITEM_HARD_STONE,   2500 },
    { ITEM_SCOPE_LENS,  2500 },
    { ITEM_MIRACLE_SEED,     3000 },
    { ITEM_CHOICE_SPECS,    3000 },
    { ITEM_AIR_BALLOON,     3000 },
    { 0xFFFF,              0    },
};

const struct MartItem sPokeathlonShopThursday[] = {
    { ITEM_YELLOW_APRICORN, 200  },
    { ITEM_PINK_APRICORN,   200  },
    { ITEM_WHITE_APRICORN,  200  },
    { ITEM_SYRUPY_APPLE,    100  },
    { ITEM_SWEET_APPLE,     2500 },
    { ITEM_TART_APPLE,      2000 },
    { ITEM_KINGS_ROCK,      3500 },
    { ITEM_LUCKY_EGG,      3000 },
    { ITEM_RED_CARD,      2500 },
    { ITEM_ROCKY_HELMET,      2500 },
    { ITEM_FLAME_ORB,     3000 },
    { ITEM_TOXIC_ORB,      3000 },
    { 0xFFFF,               0    },
};

const struct MartItem sPokeathlonShopFriday[] = {
    { ITEM_RED_APRICORN,    200  },
    { ITEM_YELLOW_APRICORN, 200  },
    { ITEM_GREEN_APRICORN,  200  },
    { ITEM_SYRUPY_APPLE,    100  },
    { ITEM_SWEET_APPLE,     2500 },
    { ITEM_TART_APPLE,      2000 },
    { ITEM_EXPERT_BELT,    500  },
    { ITEM_MUSCLE_BAND,    2500 },
    { ITEM_CHOICE_BAND,     3500 },
    { ITEM_EVERSTONE,       500  },
    { ITEM_LIFE_ORB,      3000 },
    { ITEM_SOOTHE_BELL,      3000 },
    { 0xFFFF,               0    },
};

const struct MartItem sPokeathlonShopSaturday[] = {
    { ITEM_GREEN_APRICORN,  200  },
    { ITEM_WHITE_APRICORN,  200  },
    { ITEM_BLACK_APRICORN,  200  },
    { ITEM_SYRUPY_APPLE,    100  },
    { ITEM_SWEET_APPLE,     2500 },
    { ITEM_TART_APPLE,      2000 },
    { ITEM_ABILITY_SHIELD,  1000 },
    { ITEM_EXP_SHARE,       2500 },
    { ITEM_QUICK_CLAW,      2500 },
    { ITEM_AMULET_COIN,     4000 },
    { ITEM_SMOKE_BALL,      3000 },
    { ITEM_FOCUS_BAND,      3000 },
    { 0xFFFF,               0    },
};
 
#endif // POKEATHLON_SHOP_EXPANSION
