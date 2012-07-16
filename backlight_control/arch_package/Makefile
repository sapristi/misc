

backlight-control: 
	@echo 'Building target : $@'
	g++ backlight-control.cpp -o"backlight-control" -lconfig++
	@echo 'Finished building target : $@'

clean:
	rm backlight-control

install: backlight-control

tar:
	tar -cf backlight-control.tar backlight-control.cpp backlight-control.cfg .install Makefile
