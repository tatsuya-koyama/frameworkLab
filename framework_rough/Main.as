package {

    import flash.display.Sprite;

    import tart.components.Actor;
    import tart.core.Engine;
    import tart.core.Entity;
    import tart.systems.ActorAwakenSystem;
    import tart.systems.ActorUpdateSystem;
    import tart.systems.RenderSystem;

    import game.entities.Piyo;

    [SWF(backgroundColor="#222222", frameRate="60", width="960", height="640")]
    public class Main extends Sprite {

        public function Main() {
            var engine:Engine = new Engine();
            engine.addSystems([
                 new ActorAwakenSystem()
                ,new ActorUpdateSystem()
                ,new RenderSystem()
            ]);
            engine.boot(this, _onInitComplete);

            // var miscTester:MiscTester = new MiscTester();
            // miscTester.testList();
        }

        private function _onInitComplete(engine:Engine):void {
            var piyoEntity:Entity = Piyo.create();
            engine.addEntity(piyoEntity);
        }

    }
}
