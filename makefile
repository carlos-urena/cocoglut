.SUFFIXES:
.PHONY: x, xdl, comp, dl, clean, print

exec         := bin/test1
dylib        := lib/cocoglut.dylib
stlib        := lib/cocoglut.a
exec-dl      := bin/test1-dl
comp_flags   := -std=c++11 -stdlib=libc++ -g -Iinclude -Isrc
ld_flags     := -framework OpenGL -framework Cocoa 
comp         := clang++
headers      := makefile $(wildcard src/*.h*) $(wildcard include/*.h*)
units_lib    := $(wildcard src/*.mm) $(wildcard src/*.cpp) 
units_tests  := $(wildcard test/*.c*)
units        := $(units_lib) $(units_tests)
objs_lib     := $(addprefix build/,$(addsuffix .o, $(basename $(notdir $(units_lib)))))
objs_tests   := $(addprefix build/,$(addsuffix .o, $(basename $(notdir $(units_tests)))))
objs         := $(objs_lib) $(objs_tests)




xdl: $(exec-dl)
	./$(exec-dl)

xsl: $(exec)
	./$(exec)

comp: $(exec) $(exec-dl)

sl: $(stlib)

dl: $(dylib)

clean:
	rm -rf $(exec) $(exec-dl) $(dylib) $(objs)

$(exec):	$(objs_tests) $(stlib)
	$(comp) -o $(exec) $(ld_flags) build/test1.o $(stlib)

$(exec-dl): $(objs_tests) $(dylib)
	clang++ $(ld_flags) -o $(exec-dl) build/test1.o $(dylib)

$(stlib): $(objs_lib)
	ar rcs $(stlib) $(objs_lib)

$(dylib): $(objs_lib)
	clang++ -dynamiclib -compatibility_version 1.0 -current_version 1.0 \
     $(ld_flags) $(objs_lib) -o $(dylib)

build/%.o : src/%.cpp $(headers)
	$(comp) -c $(comp_flags)  $< -o $@

build/%.o : src/%.mm $(headers)
	$(comp) -c $(comp_flags)  $< -o $@

build/%.o : test/%.cpp $(headers)
	$(comp) -c $(comp_flags)  $< -o $@







     


