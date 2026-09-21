package p509

import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 ChatWindow.
 *
 * Validated against all 6 ChatWindow instances in the supplied Interface.xdat:
 * NormalChat, TradeChat, PartyChat, ClanChat, PetitionChatWindow and SystemMsgList.
 *
 * p520 stores exactly one 32-bit packed value after DefaultProperty.
 * The old etoa5 layout used two 32-bit integers and therefore consumed the next
 * UI class marker.
 *
 * Keep the value raw until its individual byte semantics are fully identified.
 */
@Bindable
@CompileDynamic
class ChatWindow extends DefaultProperty {
    int modernPackedValue

    @Override
    ChatWindow read(InputStream input) {
        super.read(input)
        modernPackedValue = input.readInt()
        this
    }

    @Override
    ChatWindow write(OutputStream output) {
        super.write(output)
        output.writeInt(modernPackedValue)
        this
    }
}
