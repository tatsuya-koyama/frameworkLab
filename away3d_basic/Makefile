debug:
	mxmlc -swf-version=28 \
	      -debug=true \
	      -incremental=true \
	      -static-link-runtime-shared-libraries=true \
	      -library-path+="../lib/" \
	      -output="build/Main.swf" \
	      ./Main.as

run:
	adl app.xml build/ -screensize 640x960:640x960

go:
	make debug
	make run
