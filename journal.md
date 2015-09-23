
# test

## 2015-09-06 メモ

- [考えごとをある程度まとめたノート](http://docs.tatsuya-koyama.com/dev-log/entity-component/
)

### ECS

- OOP ではなくデータ指向
- Entity - Component （Component って実質 Value Object）
- Ash framework の場合
    - Component グルーピングした Node （これが pooling されてるっぽい）
    - Engine に足された System 達がこの Node を扱う （カプセル化は破る）

### DDD

- Entity - Value Object
- Factory, Repository
- Service
- レイヤ： UI / Application / Domain / Infrastructure

### 視点

- 横断的な視点 (System) / プロパティ主体
- 主観的な視点 (Actor)  / オブジェクト主体

## 2015-09-07 整理

### なぜコンポーネントに分けて、コンポーネント単位で走査する？

- メモリ効率
    - 最小のオブジェクトを最小に保てる
    - Pooling をコンポーネント単位でできる
- システムの柔軟性
    - 別の 2D 描画ライブラリ使いたい時は Engine に System 登録するところで
      RenderSystem を差し替えればいい

## 2015-09-08 具体的な実装を考える

### どんなレイヤーがあるっけ

- リソース / メモリ管理
    - Global, Chapter, Scene スコープ
- オブジェクトのライフサイクル管理
    - Pooling
- メッセージング
- 時間の制御
    - ある程度まではコマ落ち、ある程度からは処理落ち
- レイヤー管理したいシリーズ
    - 表示の前後関係（または Draw Call を考慮した描画単位）
    - Collision のグループ
    - 流れる時間の速さ
- 入力処理
- BGM と SE
- Tween
- ツール群
    - 階層型 FSM
    - 非同期処理ライブラリ
    - ローカライズ
- デバッグコンソール

### どう書きたいのか

例えば Player の Entity

    public class PlayerEntity extends Entity {
        public override function init():void {
            // イメージ
            attachComponent(PlayerLogic)
                .and(Position)
                .and(View2D)
                .and(Collision)
                .and(Tween);

            spawn();
        }
    }

実際はコンポーネントの初期パラメータを渡したり、
Pool から取得するようにしなければいけない？

    {
        // 見通し悪い……
        attachComponent(PlayerLogicFactory.get(hoge, fuga, piyo))
            .and(PositionFactory.get(0, 0))
            .and(View2DFactory.get(...))
            .and(CollisionFactory.get(...))
            .and(TweenFactory.get(...))
    }

いや、そこは Logic 側で頑張ればいいか？

    public class PlayerLogic extends ScriptComponent {
        // Component が Entity にある他の Component を取得して操作するのは許す？
        // （無かった時にランタイムエラーになるのは残念だが）
        public override function awake():void {
            _position = getComponent(Position);
            _tween    = getComponent(Tween);

            _position.x = 100;
            _position.y = 200;
            ...
        }
    }

まあ待て、Entity は Component のコンテナでしか無いんだから
Entity を継承する必要はない。必要なのは Factory だけだ


    public class PlayerFactory {
        public function create(arg1, arg2, ...):Player {
            var entity:Entity = EntityPool.getNewEntity();
            // もう可変長引数でクラス指定するみたいな感じでいきたい
            entity.attachComponents(
                PlayerLogic,
                Position,
                View2D,
                Collision,
                Tween
            ); // Pool からとるみたいなのはフレームワークレイヤーが頑張る

            eneity.init(arg1, arg2, ...);
            return entity;
        }
    }

___

    // ゲームロジックのイメージ
    //--------------------------------------------
    public function initGame():void {
        // System の初期化（上から実行順）
        Engine.addSystems(
            ScriptSystem,
            TweenSystem,
            PhysicsSystem,
            Render3DSystem,
            Render2DSystem,
            ...
        );
    }

    public function initScene():void {
        // Scene の最初に必要な Entity を置く
        addEntity(PlayerFactory.create(...));
        addEntity(EnemyGeneratorFactory.create(...));
        addEntity(ScoreFactory.create(...));
    }

うーむ……

## 2015-09-09 思考メモ

### 参考：Unity のシーケンス

- Editor Reset
- Initialization
    - Awake
    - OnEnable
    - Start
- Physics
    - FixedUpdate
    - (Internal physics update)
    - OnTriggerXXX
    - OnCollisionXXX
- Input events
    - OnMouseXXX
- Game logic
    - Update
    - Resume coroutine
    - (Internal animation update)
    - LateUpdate
- Scene rendering
    - OnWillRenderObject
    - OnPreCull
    - OnBecameVisible
    - OnBecameInvisible
    - OnPreRender
    - OnRenderObject
    - OnPostRender
    - OnRenderImage
- Gizmo rendering
- GUI rendering
- End of frame
- OnApplicationPause
- OnDisable
- Decommissioning
    - OnDestroy
    - OnApplicationQuit

### どう動く

- PlayerEntity
    - PlayerLogic, Position, View2D, ...
- EnemyEntity
    - EnemyLogic, ...
- BulletEntity
    - BulletLogic, ...

___

- ActorSystem
    - IActorComponent を扱うものとする
- PlayerLogic / EnemyLogic / BulletLogic
    - → IActorComponent を実装している
    - attach すると、なんらかの力で IActorComponent の List に登録される
    - ActorSystem はその List をイテレートする

___

    public interface IActorComponent {
        function awake():void;
        function start():void;
        function update(deltaTime:Number):void;
        function lateUpdate(deltaTime:Number):void;
    }

    // そうか、複数の System が同じ Component を操作してもいいのか
    public class InitializeSystem implements ISystem {
        public function process(deltaTime:Number):void {
            for each (var actor:IActorComponent in _actorComponents) {
                actor.awake();
            }
            for each (var actor:IActorComponent in _actorComponents) {
                actor.start();
            }
        }
    }

    public class ActorSystem implements ISystem {
        public function process(deltaTime:Number):void {
            for each (var actor:IActorComponent in _actorComponents) {
                actor.update();
            }
            for each (var actor:IActorComponent in _actorComponents) {
                actor.lateUpdate();
            }
        }
    }

    // あと Messaging System とか…

複数の Component をいじる System はどうなる？

    public class View2DSystem implements ISystem {
        public function process(deltaTime:Number):void {
            for each (var view2d:View2DComponent in _view2dComponents) {
                var displayObj:DisplayObject = view2d.displayObj;

                // View2D が attach されてる Entity から
                // TransformComponent を取得しちゃう感じ？
                var transform:TransformComponent = view2d.getComponent(TransformComponent);
                if (!transform) { /* 困る */ }

                // 毎フレームこれやるのって微妙だよなぁ
                displayObj.x = transform.x;
                displayObj.y = transform.y;
                ...

                // せめて
                if (transform.hasChanged()) {
                    ...
                }
            }
        }
    }

でも Sprite の親子関係とか誰がどう作ってどう操作するんだ

結局 Actor が操作するとかしないと、状況に応じて色々見た目の変化させたりするの大変

    public class TurtleActor implements IActorComponent {

        public static function create():Entity {
            var entity:Entity = EntityPool.getNewEntity();
            // この時点で component の初期化をするのは書くのが煩雑になるで嫌。
            // component のクラスだけ指定する感じでやりたい
            entity.attachComponents(
                TurtleActor, Transform, View2D  // ここだけ書きたい感はある
            );
            return entity;
        }

        public static function create2():Entity {
            // ヘルパークラスでも作るか  中で Pooling とかやってくれる
            return EntityBuilder.create(
                TurtleActor, Transform, View2D
            );
        }

        public function awake():void {
            // addEntity できる説？
            _childEntity = EntityBuilder.create(Transform, View2D);
            addEntity(childEntity);

            // 結局こういうことやるの？ 微妙すぎる
            var displayObj:DisplayObject = (get(View2D) as View2D).displayObj;
            var image:Image = ResouceManager.getImage('resource_name');
            displayObj.addChild(image);

            // せめて View2D 側にメソッド持たせるか（ラッパーみたいになってめんどいけど）
            // あと Actor のベースクラスでよく使うコンポーネントの参照は持っちゃう
            view2d.layer = Layers.FRONT;
            view2d.addImage('resource_name');
        }

        public function update(deltaTime:Number):void {
            _childEntity.get(Transform).rotation += 0.1 * deltaTime;
        }
    }

## イベントハンドラの命名

- GitHub でコード検索してみる
- その 1
    - onClick           → 3100 万件 Hit
    - onClicked         → 17 万
    - onButtonClick     → 10 万
    - onButtonClicked   → 2.4 万
    - onClickButton     → 2 万
- その 2
    - onContextCreated  → 1 万
    - onContextCreate   → 544
    - onContextCreation → 11
    - onCreateContext   → 5458
    - onCreatedContext  → 2
- その 3
    - onLoad            → 2870 万
    - onLoaded          → 16 万
    - onLoadComplete    → 7.3 万
    - onLoadCompleted   → 5487
    - onCompleteLoad    → 107
    - onCompletedLoad   → 0
    - onLoadDone        → 1.5 万
- on + 名詞が普通かな
- もしくは on + 目的語 + 動詞の過去形？



