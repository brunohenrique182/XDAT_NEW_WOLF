package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.*
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic
import javafx.collections.FXCollections

/**
 * Experimental Wolf-era Window layout reconstructed from the target Interface.xdat.
 *
 * Confirmed on AbilityCategory and AbilitySlot11:
 * - etoa5 saveSize is absent;
 * - legacy drawer offsetX/offsetY/directionFixed fields are absent in p520;
 * - ownerWindow follows drawerDirection/offsets;
 * - a structured modern block follows ownerWindow and contains a variable-length String;
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
    FrameDirectionType frameDirection = FrameDirectionType.None
    Boolean exitbutton
    Boolean movable
    Boolean draggable
    FrameDirectionType resizeFrameDirection = FrameDirectionType.None

    DirectionType drawerDirection = DirectionType.None

    // p520 no longer serializes the legacy drawer offsetX/offsetY/directionFixed
    // triplet here. The String immediately follows drawerDirection even when
    // drawerDirection is non-zero (verified on ChatWnd, PartyWnd, StatusWnd,
    // TargetStatusWnd, OlympiadPlayer* and other target windows).
    String ownerWindow

    // Modern Window block reconstructed structurally. The internal String makes
    // this block variable-length (81 bytes when empty, 93 for "AgitDecoWnd").
    int modernBlock01
    int modernBlock02
    int modernBlock03
    int modernBlock04
    int modernBlock05
    int modernBlock06
    int modernBlock07
    int modernBlock08
    int modernBlock09
    int modernBlock10
    int modernBlock11
    int modernBlock12
    int modernBlock13
    int modernBlock14
    String modernBlockString = ''
    int modernBlock15
    int modernBlock16
    int modernBlock17
    int modernBlock18
    int modernBlock19
    int modernBlock20

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

    /**
     * Modern frame-direction fields use -1 as None.
     * This is distinct from drawerDirection, which still uses the legacy
     * ordinal enum where 0 means None.
     */
    enum FrameDirectionType implements IntValue {
        None(-1),
        Left(0),
        Right(1),
        Top(2),
        Bottom(3),
        Free(4)

        final int value
        FrameDirectionType(int value) { this.value = value }
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
        frameDirection = input.readEnum(FrameDirectionType)
        exitbutton = input.readBoolean()
        movable = input.readBoolean()
        draggable = input.readBoolean()
        resizeFrameDirection = input.readEnum(FrameDirectionType)

        drawerDirection = input.readEnum(DirectionType)
        ownerWindow = input.readString()

        modernBlock01 = input.readInt()
        modernBlock02 = input.readInt()
        modernBlock03 = input.readInt()
        modernBlock04 = input.readInt()
        modernBlock05 = input.readInt()
        modernBlock06 = input.readInt()
        modernBlock07 = input.readInt()
        modernBlock08 = input.readInt()
        modernBlock09 = input.readInt()
        modernBlock10 = input.readInt()
        modernBlock11 = input.readInt()
        modernBlock12 = input.readInt()
        modernBlock13 = input.readInt()
        modernBlock14 = input.readInt()
        modernBlockString = input.readString()
        modernBlock15 = input.readInt()
        modernBlock16 = input.readInt()
        modernBlock17 = input.readInt()
        modernBlock18 = input.readInt()
        modernBlock19 = input.readInt()
        modernBlock20 = input.readInt()

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

        // Read children explicitly so p520 reverse-engineering failures identify the
        // owning window, failing child index and the last child that completed.
        // Serialization is unchanged: child count is still a 32-bit int and every
        // child is still a polymorphic DefaultProperty/UIEntity.
        int childCount = input.readInt()
        children = FXCollections.observableArrayList()
        DefaultProperty previousChild = null

        for (int childIndex = 0; childIndex < childCount; childIndex++) {
            try {
                DefaultProperty child = (DefaultProperty) IOUtil.readUIEntity(
                        input,
                        DefaultProperty.class.package.name,
                        DefaultProperty.class.classLoader)
                children.add(child)
                previousChild = child
            } catch (IOException e) {
                String previousDescription = previousChild == null
                        ? '<none>'
                        : "${previousChild.name}[${previousChild.class.simpleName}]"

                throw new IOException(
                        "p520 Window '${name}': failed reading child " +
                                "${childIndex + 1}/${childCount}; previous child=" +
                                previousDescription,
                        e)
            }
        }

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
        output.writeString(ownerWindow)

        output.writeInt(modernBlock01)
        output.writeInt(modernBlock02)
        output.writeInt(modernBlock03)
        output.writeInt(modernBlock04)
        output.writeInt(modernBlock05)
        output.writeInt(modernBlock06)
        output.writeInt(modernBlock07)
        output.writeInt(modernBlock08)
        output.writeInt(modernBlock09)
        output.writeInt(modernBlock10)
        output.writeInt(modernBlock11)
        output.writeInt(modernBlock12)
        output.writeInt(modernBlock13)
        output.writeInt(modernBlock14)
        output.writeString(modernBlockString)
        output.writeInt(modernBlock15)
        output.writeInt(modernBlock16)
        output.writeInt(modernBlock17)
        output.writeInt(modernBlock18)
        output.writeInt(modernBlock19)
        output.writeInt(modernBlock20)

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
