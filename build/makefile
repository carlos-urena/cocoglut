.SUFFIXES:
.PHONY: x, xdl, comp, dl, clean, xdl

exec      := main
dylibname := cocoglut.dylib
exec-dl   := main-dl

comp_flags  := -std=c++11 -stdlib=libc++ -g -I.
ld_flags    := -framework OpenGL -framework Cocoa 

comp        := clang++

headers     := makefile $(wildcard *.h)
units       := $(wildcard *.mm) $(wildcard *.cpp)
objs        := $(addsuffix .o, $(basename $(units)))
objs_nm     := $(filter-out   main.o, $(objs))

x: $(exec)
	./$(exec)

comp: $(exec)

$(exec):	$(objs)
	$(comp) -o $(exec) $(ld_flags) $(objs) 

%.o : %.cpp $(headers)
	$(comp) -c $(comp_flags)  $< -o $@

%.o : %.mm $(headers)
	$(comp) -c $(comp_flags)  $< -o $@

clean:
	rm -rf $(exec) *.o

dl: $(dylibname)

$(dylibname): $(objs_nm)
	clang++ -dynamiclib\
     -compatibility_version 1.0 -current_version 1.0 \
     $(ld_flags) \
     $(objs_nm)\
     -o $(dylibname)
     
xdl: $(exec-dl)
	./$(exec-dl)


$(exec-dl): main.o $(dylibname)
	clang++ $(ld_flags) -o $(exec-dl) main.o $(dylibname)

     


