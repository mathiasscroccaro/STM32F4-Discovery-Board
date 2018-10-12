#!/usr/bin/python3


import serial
import argparse
import numpy
import datetime
import os

serPort = "/dev/ttyACM0"


DEFAULT_PORT = "/dev/ttyACM0"
SAMPLES = 4096
CHANNELS = 1
TAM_MESSAGE = 4

class communicator:
    def __init__(self):
        self.serPort = DEFAULT_PORT
        self.f = ""
        self.n = 1
        self.v1 = 0
        self.m = 0
    
    def set(self,port=DEFAULT_PORT,n=1,v1=0,f="log.asc",m="",vg=1.0,cg=1.0):
        self.port = port
        self.n = n
        self.f = f
        self.v1 = v1
        self.m = m
        self.vg = vg
        self.cg = cg

    def reescale(self,value_list, oldMax,oldMin,newMax,newMin):
        return [(float) (((value - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin for value in value_list]

    def saveData(self,dataMatrix):
        
    
        path = datetime.datetime.now().strftime("%H-%M_%m-%d-%y")

        if (not os.path.exists(path)):
            os.makedirs(path)

        readMeFile = open(os.path.join(path,"README.md"),"w")
        readMeFile.write("#Medida IV\n")
        readMeFile.write("{}\n".format(self.m))
        readMeFile.write("Hora e data da aquisição: {}\n".format(datetime.datetime.now().strftime("%H:%M - %m/%d/%y")))
        readMeFile.close() 

        for i in range(len(dataMatrix)):
            dataFile = open(os.path.join(path,"{}.asc".format(i)),"w")
            dataFile.write("Voltage\tCurrent\n")
            
            for voltage,current in zip(dataMatrix[i][0],dataMatrix[i][1]):
                dataFile.write("{}\t{}\n".format(voltage,current))
            
            dataFile.close()

        os.system("octave-cli main.m {}".format(os.path.join(path,"{}.asc".format(i))))


    def mean(self,dataMatrix):
        
        voltage_mean = []
        current_mean = []

        for data in dataMatrix:
            voltage_mean.append(data[0])
            current_mean.append(data[1])

        voltage_mean = [sum(x)/len(dataMatrix) for x in zip (*voltage_mean)]
        current_mean = [sum(x)/len(dataMatrix) for x in zip (*current_mean)]

        return [voltage_mean, current_mean]


    def processRawData(self,message):

        bytes_list = [message[i:i+2] for i in range(0, len(message), 2)]

        int_list = [int.from_bytes(byte,byteorder='big') for byte in bytes_list]

        return int_list

    def doMeasure(self):


        VoltageList = []
        CurrentList = []

        ser = serial.Serial(port=self.serPort)
        ser.timeout = 1 

        dataMatrix = []
        
        print("Numero de medidas: {}".format(self.n))

        for i in range(self.n):
            
            print("Medida numero: {}".format(i))
            
            ser.flush()
            ser.write(bytes([1]))
            
            ser.flush()
            ser.write(bytes([2]))
            vMessage = ser.read(4096*2)
    
            ser.flush()
            ser.write(bytes([3]))
            cMessage = ser.read(4096*2)

            vMessage = self.processRawData(vMessage)
            cMessage = self.processRawData(cMessage)
        
            vMessage = self.reescale(vMessage,4096,0,3.3/self.vg,0)
            cMessage = self.reescale(cMessage,4096,0,3.3/self.cg,0)

            dataMatrix.append([vMessage,cMessage])

        dataMatrix.append(self.mean(dataMatrix))

        self.saveData(dataMatrix)

        ser.close()



if __name__ == "__main__":

    parser = argparse.ArgumentParser()

    parser.add_argument("-v1","--Vdac1",help="Voltage of the coarse grain DAC. Default = 0 V",type=float,default=0)
    parser.add_argument("-n","--NumberOfRuns",help="Number of measures. Default = 1",type=int,default=1)
    parser.add_argument("-o","--Output",help="Name of output .asc file",type=str,default="log.asc")
    parser.add_argument("-m","--Message",help="Message that will describe the output file. It is insert at the head of the file")
    parser.add_argument("-p","--Port",help="Port for simulated UART. Default = /dev/ttyACM0",type=str,default="/dev/ttyACM0")
    parser.add_argument("-vg","--VoltageGain",help="Voltage Gain. default=1",type=float,default=1.0)
    parser.add_argument("-cg","--CurrentGain",help="Current Gain. default=1",type=float,default=1.0)

    args = parser.parse_args()

    com = communicator()

    com.set(port=args.Port, n = args.NumberOfRuns, v1 = args.Vdac1, f = args.Output, m = args.Message, vg = args.VoltageGain, cg = args.CurrentGain)

    com.doMeasure()



    


    
