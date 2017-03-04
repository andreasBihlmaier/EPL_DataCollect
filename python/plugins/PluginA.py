import Cycle 
import Plugin
import PluginAPI as api
import PluginGUIAPI

class PluginA(Plugin.Plugin): 
 
  def initialize(self):
    print("INITING PLUGIN", self.getID())
    self.registerInt("MyIntStorage")
    self.registerStr("MyStrStorage")
    return True
 
  def run(self): 
    print("RUNNING PLUGIN", self.getID())
    cy = self.getCycle()
    print("amount of CN!!!:", cy.getAmountOfCN())	
    print("NODE STATUS:", cy.getNodeStatus(23))
    print("GET OD ENTRY:", cy.getODEntry(1, "234432"))
    print("Number of Nodes currently active", cy.getNumNodes()) 
    print(cy.getActiveEvents())

    print("ADDING AN EVENT !!! :", self.addEvent(6, "23")) 
    print(self.getStorage("WER"))
    print(self.setStorage("asdf", "bfdd"))
    print(self.getData("asdffff"))
    print("setting data str", self.setData("asdf", "asdf"))
    print("setting data int", self.setData("ffff", 23))
    print("setting data bool", self.setData("ffxx", False))
    print("setting random shit", self.setData("xxff", cy))
    print("startlive!!!", PluginGUIAPI.startLive(self))
    print("higlightNode!!!", PluginGUIAPI.highlightNode(self, 2))
    print("higlightODEntry!!!", PluginGUIAPI.highlightODEntry(self, 2, 1.0))
    cy2 = self.getCycleByNum(3)
    print("cy props", cy, "| cy2 props", cy2)
    print("RUNNING END PLUGIN", self.getID())

  def getID(self): 
    return "PluginA" 
 
  def getDependencies(self): 
    return "PluginA Deps" 
