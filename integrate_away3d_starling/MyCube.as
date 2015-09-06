package {

    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.ColorMaterial;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.FogMethod;
    import away3d.primitives.CubeGeometry;

    public class MyCube {

        private var _material:ColorMaterial;
        private var _geometry:CubeGeometry;
        private var _cube:Mesh;

        public function MyCube(view3D:View3D, lightPicker:StaticLightPicker, rand:KrewRandom) {
            _material = new ColorMaterial(0xffffff);
            _material.lightPicker = lightPicker;
            _material.addMethod(new FogMethod(2500, 5000, 0x224444));

            _geometry = new CubeGeometry(
                50 + rand.getUint() % 80,
                50 + rand.getUint() % 600,
                50 + rand.getUint() % 60
            );

            _cube = new Mesh(_geometry, _material);
            _cube.x = 200 + rand.getUint() % 2000;
            _cube.y = 200 + rand.getUint() % 2000;
            _cube.z = 200 + rand.getUint() % 2000;
            if (rand.getUint() % 2 == 0) { _cube.x *= -1; }
            if (rand.getUint() % 2 == 0) { _cube.y *= -1; }
            if (rand.getUint() % 2 == 0) { _cube.z *= -1; }

            _cube.rotationX = (rand.getUint() % 36000) * 0.01;
            _cube.rotationY = (rand.getUint() % 36000) * 0.01;
            _cube.rotationZ = (rand.getUint() % 36000) * 0.01;

            view3D.scene.addChild(_cube);
        }
    }
}
