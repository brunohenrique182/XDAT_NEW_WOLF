package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.*
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Experimental Wolf-era Window layout reconstructed from the target Interface.xdat.
 *
 * Confirmed on AbilityCategory and AbilitySlot11:
 * - etoa5 saveSize is absent;
 * - drawerDirection is followed by offset fields only when non-zero;
 * - ownerWindow follows drawerDirection/offsets;
 * - a fixed 81-byte modern block follows ownerWindow;
 * - the tail below aligns exactly through the children count.
 *
 * Unknown data is preserved byte-for-byte for safe round-trip research.
 */
@Bindable
@CompileDynamic
class Window extends DefaultProperty implements Iterable<DefaultProperty> {
    String parent
    @Tex String backTex
    String script
    String state
    Boolean frame
    Boolean iconable
    Boolean stuckable
    Boolean hidden
    Boolean alwaysFullAlpha
    Boolean savePosition
    @Sysstr int title = -9999
    Boolean resizeFrame
    FrameSizeType frameSize = FrameSizeType.None
    DirectionType frameDirection = DirectionType.None
    Boolean exitbutton
    Boolean movable
    Boolean draggable
    DirectionType resizeFrameDirection = DirectionType.None

    DirectionType drawerDirection = DirectionType.None
    int offsetX
    int offsetY
    Boolean directionFixed
    String ownerWindow

    transient byte[] modernWindowBlock = new byte[81]

    @Tex String iconName = 'undefined'
    int tooltipIdx = -9999
    Boolean hookKeyInput
    String workingConfiguration

    @Tex String leftTextureName = 'undefined'
    @Tex String midTextureName = 'undefined'
    @Tex String rightTextureName = 'undefined'
    @Tex String minimizeBtnTextureNormal = 'undefined'
    @Tex String minimizeBtnTexturePushed = 'undefined'

    int modernTailInt01 = -9999
    int modernTailInt02 = -9999
    int modernTailInt03 = -9999
    int modernTailInt04 = -9999
    String modernTailString = 'undefined'

    @Type(State.class)
    List<State> additionalState = []

    Boolean useParentClipRect
    Boolean showInArena
    Boolean modernTailBool01
    int modernTailInt05 = -9999
    int modernTailInt06 = -9999
    int modernTailInt07 = -9999
    int modernTailInt08 = -9999
    Boolean modernTailBool02

    @Type(DefaultProperty.class)
    List<DefaultProperty> children = []

    @Override
    Iterator<DefaultProperty> iterator() {
        children.iterator()
    }

    @DefaultIO
    static class State implements IOEntity {
        String unk148

        @Override
        String toString() { State.class.simpleName }
    }

    enum FrameSizeType implements IntValue {
        None(-1), Big(0), Small(1)

        final int value
        FrameSizeType(int value) { this.value = value }
        @Override int intValue() { value }
    }

    enum DirectionType {
        None, Left, Right, Top, Bottom, Free
    }

    @Override
    Window read(InputStream input) {
        super.read(input)

        parent = input.readString()
        backTex = input.readString()
        script = input.readString()
        state = input.readString()
        frame = input.readBoolean()
        iconable = input.readBoolean()
        stuckable = input.readBoolean()
        hidden = input.readBoolean()
        alwaysFullAlpha = input.readBoolean()
        savePosition = input.readBoolean()
        title = input.readInt()
        resizeFrame = input.readBoolean()
        frameSize = input.readEnum(FrameSizeType)
        frameDirection = input.readEnum(DirectionType)
        exitbutton = input.readBoolean()
        movable = input.readBoolean()
        draggable = input.readBoolean()
        resizeFrameDirection = input.readEnum(DirectionType)

        drawerDirection = input.readEnum(DirectionType)
        if (drawerDirection.ordinal() > 0) {
            offsetX = input.readInt()
            offsetY = input.readInt()
            directionFixed = input.readBoolean()
        }

        ownerWindow = input.readString()

        modernWindowBlock = new byte[81]
        new DataInputStream(input).readFully(modernWindowBlock)

        iconName = input.readString()
        tooltipIdx = input.readInt()
        hookKeyInput = input.readBoolean()
        workingConfiguration = input.readString()

        leftTextureName = input.readString()
        midTextureName = input.readString()
        rightTextureName = input.readString()
        minimizeBtnTextureNormal = input.readString()
        minimizeBtnTexturePushed = input.readString()

        modernTailInt01 = input.readInt()
        modernTailInt02 = input.readInt()
        modernTailInt03 = input.readInt()
        modernTailInt04 = input.readInt()
        modernTailString = input.readString()

        additionalState = input.readList(State, ArrayLength.COMPACT_INT)

        useParentClipRect = input.readBoolean()
        showInArena = input.readBoolean()
        modernTailBool01 = input.readBoolean()
        modernTailInt05 = input.readInt()
        modernTailInt06 = input.readInt()
        modernTailInt07 = input.readInt()
        modernTailInt08 = input.readInt()
        modernTailBool02 = input.readBoolean()

        children = input.readList(DefaultProperty)
        this
    }

    @Override
    Window write(OutputStream output) {
        super.write(output)

        output.writeString(parent)
        output.writeString(backTex)
        output.writeString(script)
        output.writeString(state)
        output.writeBoolean(frame)
        output.writeBoolean(iconable)
        output.writeBoolean(stuckable)
        output.writeBoolean(hidden)
        output.writeBoolean(alwaysFullAlpha)
        output.writeBoolean(savePosition)
        output.writeInt(title)
        output.writeBoolean(resizeFrame)
        output.writeEnum(frameSize)
        output.writeEnum(frameDirection)
        output.writeBoolean(exitbutton)
        output.writeBoolean(movable)
        output.writeBoolean(draggable)
        output.writeEnum(resizeFrameDirection)

        output.writeEnum(drawerDirection)
        if (drawerDirection.ordinal() > 0) {
            output.writeInt(offsetX)
            output.writeInt(offsetY)
            output.writeBoolean(directionFixed)
        }

        output.writeString(ownerWindow)

        if (modernWindowBlock == null || modernWindowBlock.length != 81)
            throw new IOException("p509 Window modern block must contain exactly 81 bytes")
        output.write(modernWindowBlock)

        output.writeString(iconName)
        output.writeInt(tooltipIdx)
        output.writeBoolean(hookKeyInput)
        output.writeString(workingConfiguration)

        output.writeString(leftTextureName)
        output.writeString(midTextureName)
        output.writeString(rightTextureName)
        output.writeString(minimizeBtnTextureNormal)
        output.writeString(minimizeBtnTexturePushed)

        output.writeInt(modernTailInt01)
        output.writeInt(modernTailInt02)
        output.writeInt(modernTailInt03)
        output.writeInt(modernTailInt04)
        output.writeString(modernTailString)

        output.writeList(additionalState, ArrayLength.COMPACT_INT)

        output.writeBoolean(useParentClipRect)
        output.writeBoolean(showInArena)
        output.writeBoolean(modernTailBool01)
        output.writeInt(modernTailInt05)
        output.writeInt(modernTailInt06)
        output.writeInt(modernTailInt07)
        output.writeInt(modernTailInt08)
        output.writeBoolean(modernTailBool02)

        output.writeList(children)
        this
    }
}
