import tkinter as tk
import ftd2xx as ftdi
from tkinter import *
# import random
# import time
import logging

# Configure the logging settings
logging.basicConfig(
    filename='MTS.log',  # Log to a file (optional)
    level=logging.DEBUG,      # Set the logging level to DEBUG or higher
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
)

# Create a logger with the name 'Encoder_logger'
logger = logging.getLogger('MTS_logger')
#----------------------------------------------------------------------------------

class MyWindow:
    def __init__(self, root, fthandle):
        self.root = root
        self.root.state('zoomed')               # maximize
        self.root.geometry("700x900")
        self.root.title('MTS')                  # window titlebar
        self.root.configure(bg="#b2d4b6")       # colour

        self.font1= ("ITC-Bold",20)
        self.font2 = ("Helvetica",14)
        self.font3 = ("ITC-Bold",20)

        self.variable11 = tk.StringVar()
        self.variable12 = tk.StringVar()
        self.variable13 = tk.StringVar()
        self.variable14 = tk.StringVar()
        self.variable15 = tk.StringVar()
        self.variable16 = tk.StringVar()
        self.variable17 = tk.StringVar()
        self.variable18 = tk.StringVar()

        self.variable21 = tk.StringVar()
        self.variable22 = tk.StringVar()    
        self.variable23 = tk.StringVar()
        self.variable24 = tk.StringVar()
        self.variable25 = tk.StringVar()
        self.variable26 = tk.StringVar()
        self.variable27 = tk.StringVar()
        self.variable28 = tk.StringVar()

        self.variable31 = tk.StringVar()
        self.variable32 = tk.StringVar()
        self.variable33 = tk.StringVar()
        self.variable34 = tk.StringVar()
        self.variable35 = tk.StringVar()
        self.variable36 = tk.StringVar()
        self.variable37 = tk.StringVar()
        self.variable38 = tk.StringVar()

        self.variable41 = tk.StringVar()
        self.variable42 = tk.StringVar()
        self.variable43 = tk.StringVar()
        self.variable44 = tk.StringVar()
        self.variable45 = tk.StringVar()
        self.variable46 = tk.StringVar()
        self.variable47 = tk.StringVar()
        self.variable48 = tk.StringVar()

        self.variable51 = tk.StringVar()
        self.variable52 = tk.StringVar()
        self.variable53 = tk.StringVar()
        self.variable54 = tk.StringVar()
        self.variable55 = tk.StringVar()
        self.variable56 = tk.StringVar()
        self.variable57 = tk.StringVar()
        self.variable58 = tk.StringVar()

        self.variable11.set("NA")
        self.variable12.set("NA")
        self.variable13.set("NA")
        self.variable14.set("NA")
        self.variable15.set("NA")
        self.variable16.set("NA")
        self.variable17.set("NA")
        self.variable18.set("NA")

        self.variable21.set("NA")
        self.variable22.set("NA")
        self.variable23.set("NA")
        self.variable24.set("NA")
        self.variable25.set("NA")
        self.variable26.set("NA")
        self.variable27.set("NA")
        self.variable28.set("NA")

        self.variable31.set("NA")
        self.variable32.set("NA")
        self.variable33.set("NA")
        self.variable34.set("NA")
        self.variable35.set("NA")
        self.variable36.set("NA")
        self.variable37.set("NA")
        self.variable38.set("NA")

        self.variable41.set("NA")
        self.variable42.set("NA")
        self.variable43.set("NA")
        self.variable44.set("NA")
        self.variable45.set("NA")
        self.variable46.set("NA")
        self.variable47.set("NA")
        self.variable48.set("NA")

        self.variable51.set("NA")
        self.variable52.set("NA")
        self.variable53.set("NA")
        self.variable54.set("NA")
        self.variable55.set("NA")
        self.variable56.set("NA")
        self.variable57.set("NA")
        self.variable58.set("NA") 

        #self.root.attributes('-alpha', 0.5)    # transperency
        self.create_widgets()
        self.recievedata()
           
        
    def recievedata(self):
        fthandle.setBitMode(0x00, 0x40) 
        #set value 
        data = 0
        
        try:
            
                #check any data present in RX_buffer 
                RX_buffer_data  = fthandle.getQueueStatus()

                #wait until Encoder data received 
                while RX_buffer_data == 0:
                    RX_buffer_data  = fthandle.getQueueStatus()
                    print(RX_buffer_data)


                #means RX buffer contain data 
                if RX_buffer_data != 0:
                    print(f'RX_buffer_data = {RX_buffer_data}') 
                    logger.info(f' RX_buffer_data= {RX_buffer_data}')

                    data = fthandle.read(RX_buffer_data)  

                 # Convert data to hexadecimal representation
                hex_data = " ".join("{:02x}".format(byte) for byte in data)

                   
                hex_data_without_spaces = hex_data.replace(" ", "")

                # print("hex_data_without_spaces = ", hex_data_without_spaces)
                logger.info(f'-------------------->hex_data_without_spaces = {hex_data_without_spaces}')

                data = hex_data_without_spaces
                pattern = "5a5a5a"
                subpattern = "a5a5a5"
                subextracted_data = ""
                remaining_data = data
                index = remaining_data.find(pattern)  # Find the index of the pattern
                while index != -1:  # If the pattern is found
                    extracted_data = remaining_data[index:]  # Extract the substring from the pattern onward
                    subindex = extracted_data.find(subpattern)  # Find the index of the subpattern
                    if subindex != -1:  # If the subpattern is found
                        subextracted_data = extracted_data[:subindex + len(subpattern)]  # Extract the substring between pattern and subpattern
                        print(subextracted_data)
                        remaining_data = extracted_data[subindex + len(subpattern):]  # Update remaining data for next iteration
                        index = remaining_data.find(pattern)  # Find the index of the next pattern
                    else:
                        print("Subpattern not found in the extracted data.")
                        break
                else:
                    print("Pattern not found in the data.")

                a = subextracted_data[:6]
                b = subextracted_data[6:8]
                c = subextracted_data[8:14]
                d = subextracted_data[14:20]
                e = subextracted_data[20:26]
                f = subextracted_data[26:32]
                g = subextracted_data[32:38]
                h = subextracted_data[38:44]
                i = subextracted_data[44:50]
                j= subextracted_data[50:56]
                # Store in separate variables
                self.values = [a, b, c, d, e, f, g, h, i, j]
                print(self.values)

                   
        except FileNotFoundError:
            print("File not found.")
        
        if a == "01":
            self.variable11.set(f"{round((247 *(int(b,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable12.set(f"{round((247 *(int(c,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable13.set(f"{round((247 *(int(d,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable14.set(f"{round((247 *(int(e,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable15.set(f"{round((247 *(int(f,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable16.set(f"{round((247 *(int(g,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable17.set(f"{round((247 *(int(h,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable18.set(f"{round((247 *(int(i,16)*(1.966953395*1e-7))) - 242,4)} °C" )
        elif a=="02":
            self.variable21.set(f"{round((247 *(int(b,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable22.set(f"{round((247 *(int(c,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable23.set(f"{round((247 *(int(d,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable24.set(f"{round((247 *(int(e,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable25.set(f"{round((247 *(int(f,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable26.set(f"{round((247 *(int(g,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable27.set(f"{round((247 *(int(h,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable28.set(f"{round((247 *(int(i,16)*(1.966953395*1e-7))) - 242,4)} °C" )
        elif a=="03":
            self.variable31.set(f"{round((247 *(int(b,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable32.set(f"{round((247 *(int(c,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable33.set(f"{round((247 *(int(d,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable34.set(f"{round((247 *(int(e,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable35.set(f"{round((247 *(int(f,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable36.set(f"{round((247 *(int(g,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable37.set(f"{round((247 *(int(h,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable38.set(f"{round((247 *(int(i,16)*(1.966953395*1e-7))) - 242,4)} °C" )
        elif a=="04":
            self.variable41.set(f"{round((247 *(int(b,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable42.set(f"{round((247 *(int(c,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable43.set(f"{round((247 *(int(d,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable44.set(f"{round((247 *(int(e,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable45.set(f"{round((247 *(int(f,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable46.set(f"{round((247 *(int(g,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable47.set(f"{round((247 *(int(h,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable48.set(f"{round((247 *(int(i,16)*(1.966953395*1e-7))) - 242,4)} °C" )
        elif a=="05":
            self.variable51.set(f"{round((247 *(int(b,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable52.set(f"{round((247 *(int(c,16)*(1.966953395*1e-7))) - 242,4)} °C" )
            
            self.variable53.set(f"{round((247 *(int(d,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable54.set(f"{round((247 *(int(e,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable55.set(f"{round((247 *(int(f,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable56.set(f"{round((247 *(int(g,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable57.set(f"{round((247 *(int(h,16)*(1.966953395*1e-7))) - 242,4)} °C" )

            self.variable58.set(f"{round((247 *(int(i,16)*(1.966953395*1e-7))) - 242,4)} °C" )
        else:
            print("provide valid ID")


        self.root.after(1000, self.recievedata)

        
    def create_widgets(self):
        self.label11 = tk.Label(self.root, text = "Channel 1",bg="#b2d4b6",font =self.font1)
        self.label11.place(x=70, y=100)
        
        self.label12 = tk.Label(self.root, text = "Channel 2",bg="#b2d4b6",font =self.font1)
        self.label12.place(x=70, y=180)
        
        self.label13 = tk.Label(self.root, text = "Channel 3",bg="#b2d4b6",font =self.font1)
        self.label13.place(x=70, y=260)

        self.label14 = tk.Label(self.root, text = "Channel 4",bg="#b2d4b6",font =self.font1)
        self.label14.place(x=70, y=340)

        self.label15 = tk.Label(self.root, text = "Channel 5",bg="#b2d4b6",font =self.font1)
        self.label15.place(x=70, y=420)

        self.label16 = tk.Label(self.root, text = "Channel 6",bg="#b2d4b6",font =self.font1)
        self.label16.place(x=70, y=500)

        self.label17 = tk.Label(self.root, text = "Channel 7",bg="#b2d4b6",font =self.font1)
        self.label17.place(x=70, y=580)

        self.label18 = tk.Label(self.root, text = "Channel 8",bg="#b2d4b6",font =self.font1)
        self.label18.place(x=70, y=660)



        self.label10 = tk.Label(self.root, text = "MTS 1",bg="#b2d4b6",font =self.font3)
        self.label10.place(x=320, y=50)

        self.text11 = tk.Label(self.root, height=2, width=20, textvariable = self.variable11,font =self.font2)
        self.text11.place(x=250, y=100)
        
        self.text12 = tk.Label(self.root, height=2, width=20, textvariable = self.variable12,font =self.font2)
        self.text12.place(x=250, y=180)

        self.text13 = tk.Label(self.root, height=2, width=20, textvariable= self.variable13,font =self.font2)
        self.text13.place(x=250, y=260)

        self.text14 = tk.Label(self.root, height=2, width=20, textvariable= self.variable14,font =self.font2)
        self.text14.place(x=250, y=340)

        self.text15 = tk.Label(self.root, height=2, width=20, textvariable= self.variable15,font =self.font2)
        self.text15.place(x=250, y=420)

        self.text16 = tk.Label(self.root, height=2, width=20, textvariable= self.variable16,font =self.font2)
        self.text16.place(x=250, y=500)

        self.text17 = tk.Label(self.root, height=2, width=20, textvariable= self.variable17,font =self.font2)
        self.text17.place(x=250, y=580)

        self.text18 = tk.Label(self.root, height=2, width=20, textvariable= self.variable18,font =self.font2)
        self.text18.place(x=250, y=660)

        
        self.label20 = tk.Label(self.root, text = "MTS 2",bg="#b2d4b6",font =self.font3)
        self.label20.place(x=570, y=50)

        self.text21 = tk.Label(self.root, height=2, width=20, textvariable = self.variable21,font =self.font2)
        self.text21.place(x=500, y=100)
        
        self.text22 = tk.Label(self.root, height=2, width=20, textvariable = self.variable22,font =self.font2)
        self.text22.place(x=500, y=180)

        self.text23 = tk.Label(self.root, height=2, width=20, textvariable= self.variable23,font =self.font2)
        self.text23.place(x=500, y=260)

        self.text24 = tk.Label(self.root, height=2, width=20, textvariable= self.variable24,font =self.font2)
        self.text24.place(x=500, y=340)

        self.text25 = tk.Label(self.root, height=2, width=20, textvariable= self.variable25,font =self.font2)
        self.text25.place(x=500, y=420)

        self.text26 = tk.Label(self.root, height=2, width=20, textvariable= self.variable26,font =self.font2)
        self.text26.place(x=500, y=500)

        self.text27 = tk.Label(self.root, height=2, width=20, textvariable= self.variable27,font =self.font2)
        self.text27.place(x=500, y=580)

        self.text28 = tk.Label(self.root, height=2, width=20, textvariable= self.variable28,font =self.font2)
        self.text28.place(x=500, y=660)


        self.label30 = tk.Label(self.root, text = "MTS 3",bg="#b2d4b6",font =self.font3)
        self.label30.place(x=820, y=50)

        self.text31 = tk.Label(self.root, height=2, width=20, textvariable = self.variable31,font =self.font2)
        self.text31.place(x=750, y=100)
        
        self.text32 = tk.Label(self.root, height=2, width=20, textvariable = self.variable32,font =self.font2)
        self.text32.place(x=750, y=180)

        self.text33 = tk.Label(self.root, height=2, width=20, textvariable= self.variable33,font =self.font2)
        self.text33.place(x=750, y=260)

        self.text34 = tk.Label(self.root, height=2, width=20, textvariable= self.variable34,font =self.font2)
        self.text34.place(x=750, y=340)

        self.text35 = tk.Label(self.root, height=2, width=20, textvariable= self.variable35,font =self.font2)
        self.text35.place(x=750, y=420)

        self.text36 = tk.Label(self.root, height=2, width=20, textvariable= self.variable36,font =self.font2)
        self.text36.place(x=750, y=500)

        self.text37 = tk.Label(self.root, height=2, width=20, textvariable= self.variable37,font =self.font2)
        self.text37.place(x=750, y=580)

        self.text38 = tk.Label(self.root, height=2, width=20, textvariable= self.variable38,font =self.font2)
        self.text38.place(x=750, y=660)


        self.label40 = tk.Label(self.root, text = "MTS 4",bg="#b2d4b6",font =self.font3)
        self.label40.place(x=1070, y=50)

        self.text41 = tk.Label(self.root, height=2, width=20, textvariable = self.variable41,font =self.font2)
        self.text41.place(x=1000, y=100)
        
        self.text42 = tk.Label(self.root, height=2, width=20, textvariable = self.variable42,font =self.font2)
        self.text42.place(x=1000, y=180)

        self.text43 = tk.Label(self.root, height=2, width=20, textvariable= self.variable43,font =self.font2)
        self.text43.place(x=1000, y=260)

        self.text44 = tk.Label(self.root, height=2, width=20, textvariable= self.variable44,font =self.font2)
        self.text44.place(x=1000, y=340)

        self.text45 = tk.Label(self.root, height=2, width=20, textvariable= self.variable45,font =self.font2)
        self.text45.place(x=1000, y=420)

        self.text46 = tk.Label(self.root, height=2, width=20, textvariable= self.variable46,font =self.font2)
        self.text46.place(x=1000, y=500)

        self.text47 = tk.Label(self.root, height=2, width=20, textvariable= self.variable47,font =self.font2)
        self.text47.place(x=1000, y=580)

        self.text48 = tk.Label(self.root, height=2, width=20, textvariable= self.variable48,font =self.font2)
        self.text48.place(x=1000, y=660)



        self.label40 = tk.Label(self.root, text = "MTS 5",bg="#b2d4b6",font =self.font3)
        self.label40.place(x=1320, y=50)

        self.text41 = tk.Label(self.root, height=2, width=20, textvariable = self.variable51,font =self.font2)
        self.text41.place(x=1250, y=100)
        
        self.text42 = tk.Label(self.root, height=2, width=20, textvariable = self.variable52,font =self.font2)
        self.text42.place(x=1250, y=180)

        self.text43 = tk.Label(self.root, height=2, width=20, textvariable= self.variable53,font =self.font2)
        self.text43.place(x=1250, y=260)

        self.text44 = tk.Label(self.root, height=2, width=20, textvariable= self.variable54,font =self.font2)
        self.text44.place(x=1250, y=340)

        self.text45 = tk.Label(self.root, height=2, width=20, textvariable= self.variable55,font =self.font2)
        self.text45.place(x=1250, y=420)

        self.text46 = tk.Label(self.root, height=2, width=20, textvariable= self.variable56,font =self.font2)
        self.text46.place(x=1250, y=500)

        self.text47 = tk.Label(self.root, height=2, width=20, textvariable= self.variable57,font =self.font2)
        self.text47.place(x=1250, y=580)

        self.text48 = tk.Label(self.root, height=2, width=20, textvariable= self.variable58,font =self.font2)
        self.text48.place(x=1250, y=660)


        
        # self.checkbox = tk.Checkbutton(self.root, text= "I Agree",variable=self.Var1, height=1, width=5,bg="#b2d4b6")
        # self.checkbox.place(x=800, y=500)
        
        # self.root.after(1000, self.recievedata)  # Schedule the initial data update after 1000 milliseconds

        # self.button= tk.Button(self.root, text = "Read Data",command= self.recievedata , bd=5, bg='#cccccc',height=2,width=15,cursor="hand2",relief="raised" )
        # self.button.place(x=700, y=800)

        # root.bind("<Return>", lambda event: self.button.invoke())
        
        
        

if __name__ == "__main__":
    root = tk.Tk()
    fthandle = None
    try:
        fthandle = ftdi.open(0)
        print(f'self.fthandle  = {fthandle}')
    except:
        print("Failed to open device")
    app = MyWindow(root,fthandle)
    
    root.mainloop()
