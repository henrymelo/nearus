//
//  Contato.m
//  ContatosIP67
//
//  Created by ios7289 on 1/6/18.
//  Copyright © 2018 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato

@dynamic nome, telefone, endereco, site, latitude, longitude, foto;

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *)title {
    return self.nome;
}

-(NSString *)subtitle {
    return self.site;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@, Endereço: %@, Site: %@", self.nome, self.telefone, self.endereco, self.site];
}

@end
