#include "../../include/types.h"
#include "../../include/constants/pokemon.h"
#include "../../include/script.h"

typedef struct CasinoTemplate {
    u32 init;
    u32 main;
    u32 exit;
    u32 overlay;
} CasinoTemplate;

typedef struct SlotsLaunchArgs {
    void *coins;
    void *options;
    void *menuInputState;
    void *profile;
    void *saveData;
    u32 luck;
} SlotsLaunchArgs;

void *LONG_CALL Casino_AllocAtEnd(u32 heap, u32 size);
void *LONG_CALL Casino_GetCoins(void *saveData);
void *LONG_CALL Casino_GetOptions(void *saveData);
u32 LONG_CALL Casino_GetLuck(void *saveData, u32 machine, u32 city);
void *LONG_CALL Casino_LaunchVoltorbFlip(FieldSystem *field, u32 luck);
void LONG_CALL Casino_LaunchApplication(FieldSystem *field, const CasinoTemplate *template, void *args);
void LONG_CALL Casino_SetupNativeScript(SCRIPTCONTEXT *ctx, void *callback);

// Stable entry veneers at payload offsets 0x14, 0x1C and 0x24.
static const CasinoTemplate sSlotsTemplate = {
    0x021E5915, 0x021E591D, 0x021E5925, 77
};

BOOL ScrCmd_CasinoGameSelect(SCRIPTCONTEXT *ctx)
{
    u32 machine = ScriptReadByte(ctx);
    u32 game = ScriptReadByte(ctx);
    FieldSystem *field = ctx->fsys;
    // Native command 780 stores its allocation in script environment field 20.
    void **runningArgs = FieldSysGetAttrAddr(field, SCRIPTENV_AC);
    u32 luck = Casino_GetLuck(field->savedata, machine, game & 1);

    if (game < 2) {
        *runningArgs = Casino_LaunchVoltorbFlip(field, luck);
    } else {
        SlotsLaunchArgs *args = Casino_AllocAtEnd(11, sizeof(*args));
        args->coins = Casino_GetCoins(field->savedata);
        args->options = Casino_GetOptions(field->savedata);
        args->menuInputState = (u8 *)field + 0x10C;
        args->profile = Sav2_PlayerData_GetProfileAddr(field->savedata);
        args->saveData = field->savedata;
        args->luck = luck;
        *runningArgs = args;
        Casino_LaunchApplication(field, &sSlotsTemplate, args);
    }

    Casino_SetupNativeScript(ctx, (void *)0x02042975);
    return TRUE;
}
