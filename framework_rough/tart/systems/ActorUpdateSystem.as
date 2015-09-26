package tart.systems {

    import tart.components.Actor;
    import tart.core.System;
    import tart.core.TartContext;
    import tart.utils.IIterator;
    import tart.utils.LinkedList;

    public class ActorUpdateSystem extends System{

        private var _components:LinkedList;
        private var _componentIter:IIterator;

        public override function init():void {
            _components    = getComponents(Actor);
            _componentIter = _components.iterator();
        }

        public override function process(tartContext:TartContext):void {
            for (var actor:Actor = _componentIter.head(); actor; actor = _componentIter.next()) {
                actor.update(1/60);  // ToDo: pass delta time
            }
        }

    }
}
