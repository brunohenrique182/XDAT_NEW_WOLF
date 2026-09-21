package p509

import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.transform.CompileDynamic
import javafx.scene.paint.Color

/**
 * Wolf Waker / p520 chat channel definition.
 *
 * Binary-validated against the supplied Interface.xdat and
 * InterfaceClassic.xdat. p520 serializes 30 channel entries (0..29) and
 * stores two RGBA colors per entry. The legacy etoa5 definition only knew
 * channels 0..25 and one color, causing the second color of channel 0 to be
 * interpreted as the next enum value.
 */
@DefaultIO
@CompileDynamic
class ChatChannelDefinition implements IOEntity {
    ChatType chatType = ChatType.NORMAL
    Color chatColor = new Color(0.0, 0.0, 0.0, 0.0)
    Color chatColorSecondary = new Color(0.0, 0.0, 0.0, 0.0)

    @Override
    String toString() {
        chatType.name()
    }

    enum ChatType {
        NORMAL,
        SHOUT,
        TELL,
        PARTY,
        CLAN,
        SYSTEM,
        USER_PET,
        GM_PET,
        MARKET,
        ALLIANCE,
        ANNOUNCE,
        CUSTOM,
        L2_FRIEND,
        MSN_CHAT,
        PARTY_ROOM_CHAT,
        COMMANDER_CHAT,
        INTER_PARTYMASTER_CHAT,
        HERO,
        CRITICAL_ANNOUNCE,
        SCREEN_ANNOUNCE,
        DOMINIONWAR,
        MPCC_ROOM,
        NPC_NORMAL,
        NPC_SHOUT,
        FRIEND_ANNOUNCE,
        WORLD,
        MODERN_26,
        MODERN_27,
        MODERN_28,
        MODERN_29
    }
}
