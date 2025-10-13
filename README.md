# QuestScrCpy
Screen and Sound stream for VR HMDs(base on scrcpy ~~and sndcpy~~).

## How to use it?
1. **Preparation**
    - Ensure your VR HMD is powered on and connected to your computer via a USB cable.
    - Enable the developer mode on your VR HMD (different VR headsets have different activation methods. Please search for relevant information online).
    - Confirm that the necessary drivers are installed on your computer.

2. **Run the Script**
   - Locate the `GetHMDView.bat` file in the root directory.
   - Double - click the `GetHMDView.bat` file, or navigate to the directory where the file is located in the command line, then type `GetHMDView.bat` and press Enter.

3. **Check the Connection**
   - Observe the prompt messages in the command - line window to ensure that the first three checks have passed.
    > Step 1. Connect the headset via usb cable.  
    > Step 2. Enable computer to access files on headset.  
    > Step 3. Enable debug mode with usb cable, if dialog showed.

   - If the USB connection status, VR headset developer mode, and computer access permissions detection passed, press Enter to proceed to the next step.

4. **Select Connection Parameters**
   - In `Step 4`, select the connection mode according to the prompts.

   > 0: USB Connection  
   > 1: WIFI Connection

   - When selecting the USB connection, make sure that the device name detected by the computer is the name of the headset. You should see information similar to the following:

   > Step 4.1 Get connected device name.  
   >    Your connecting device is : XXXXXXXXXX

   - When selecting the WIFI connection, ensure that the headset and the computer are on the same network. You should see information similar to the following:

   >    Step 4.1 Enable Wifi mode.  
   > restarting in TCP mode port: 5555  
   >    Step 4.2 Disconnect exist connection for WIFI connection.  
   >    Step 4.3 Input the headset's ip address.  
   > Please input the HMD's ip address here:

    Enter the IP address of the headset according to the prompt.

    - If the connection is normal, you should see a prompt message indicating that the device is connected successfully.
    > Your connecting device is : XXXXXXXXXX

    - For the first connection, you may need to confirm the connection permission on the headset. Please check if there is such a message on the headset. If so, click "Allow". Subsequent connections can be ignored. (Refer to the prompt in `Step 5`)

    - At this point, the program will automatically configure the connection environment between the headset and the computer.

    - In the last step, select the type of headset you are connecting to. Currently, the best viewing modes for devices such as Quest2, Quest3, PICO NEO3, and PICO 4 are supported. You will see information similar to the following:
    > Step 7. Specify the stream device,  
    >    0 for Oculus Quest2 and  
    >    1 for PICO Neo X :  
    > Your choice for device [0:Quest|1:PICO4|2:PICO3|3:Quest3]:


    - Enter the type of the connected headset according to the prompt. For example, entering `0` means you are connecting a Quest2. Then the configuration for that headset will be completed, and the scrcpy program will run.

5. **End Usage**
   - After you finish using it, close the window that is displaying the VR HMD screen.
   - Press `Ctrl + C` in the command - line window to terminate the script.
   - Disconnect the USB connection between the VR HMD and the computer.

### **Operation Demonstration**
- Please refer to the video demonstration below to see how to use the script.  
    [Youtube video](https://www.youtube.com/embed/LVmcopq82HA)


- Or watch the video on bilibili  
    [Bilibili video](https://player.bilibili.com/player.html?isOutside=true&aid=115360187549137&bvid=BV16J4uzyEsp&cid=33013960232&p=1)
