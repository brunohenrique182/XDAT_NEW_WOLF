package p509

import acmi.l2.clientmod.util.IntValue
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

@Bindable
@CompileDynamic
class EditBox extends DefaultProperty {
    Type type = Type.NORMAL
    int maxLength
    Boolean showCursor
    Boolean chatMarkOn
    int offsetX = -9999
    Boolean candidateBoxShowUpPos
    Boolean useAutoCompletion
    BooleanEvent enableCopyNPaste = BooleanEvent.Default

    int modernInt01
    int modernInt02
    int modernInt03

    String modernString01 = 'undefined'
    String modernString02 = 'undefined'
    String modernString03 = 'undefined'
    String modernString04 = 'undefined'
    String modernString05 = 'undefined'
    String modernString06 = 'undefined'
    String modernString07 = 'undefined'

    int modernTail01 = -9999
    int modernTail02 = -9999

    enum Type {
        NORMAL,
        CHAT,
        PASSWORD,
        NUMBER,
        DATE,
        TIME,
        ID
    }

    enum BooleanEvent implements IntValue {
        Default(-1),
        False(0),
        True(1),
        Event(2);

        final int value

        BooleanEvent(int value) { this.value = value }
        @Override int intValue() { value }
    }

    @Override
    EditBox read(InputStream input) {
        super.read(input)
        type = input.readEnum(Type)
        maxLength = input.readInt()
        showCursor = input.readBoolean()
        chatMarkOn = input.readBoolean()
        offsetX = input.readInt()
        candidateBoxShowUpPos = input.readBoolean()
        useAutoCompletion = input.readBoolean()
        enableCopyNPaste = input.readEnum(BooleanEvent)

        modernInt01 = input.readInt()
        modernInt02 = input.readInt()
        modernInt03 = input.readInt()

        modernString01 = input.readString()
        modernString02 = input.readString()
        modernString03 = input.readString()
        modernString04 = input.readString()
        modernString05 = input.readString()
        modernString06 = input.readString()
        modernString07 = input.readString()

        modernTail01 = input.readInt()
        modernTail02 = input.readInt()
        this
    }

    @Override
    EditBox write(OutputStream output) {
        super.write(output)
        output.writeEnum(type)
        output.writeInt(maxLength)
        output.writeBoolean(showCursor)
        output.writeBoolean(chatMarkOn)
        output.writeInt(offsetX)
        output.writeBoolean(candidateBoxShowUpPos)
        output.writeBoolean(useAutoCompletion)
        output.writeEnum(enableCopyNPaste)

        output.writeInt(modernInt01)
        output.writeInt(modernInt02)
        output.writeInt(modernInt03)

        output.writeString(modernString01)
        output.writeString(modernString02)
        output.writeString(modernString03)
        output.writeString(modernString04)
        output.writeString(modernString05)
        output.writeString(modernString06)
        output.writeString(modernString07)

        output.writeInt(modernTail01)
        output.writeInt(modernTail02)
        this
    }
}
