local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local LeaderstatsClient = {}


function LeaderstatsClient.fetchUpdate(self : LeaderstatsClient, newValue : number)
    print('Methods has changed to update with new value: '.. tostring(newValue))
    print('Coisado')
    -- AKI COLOCA PARA SLA UMA UI ATUALIZAR COM O VALOR QUE O SERVIDOR MANDAR 
    -- Tipo quando isso for ativado da para meter efeito de dinheiro na tela e tals pois é metodo então não usa evento direto
    
end

function LeaderstatsClient.init(self : LeaderstatsClient)
    self.networker = Networker.client.new('LeaderstatsService', self, {
        self.fetchUpdate
    })
end

type LeaderstatsClient = typeof(LeaderstatsClient)

return LeaderstatsClient