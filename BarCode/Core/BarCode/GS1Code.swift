//
//  GS1Code.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/20.
//

// Reference: https://en.wikipedia.org/wiki/List_of_GS1_country_codes

import Foundation

public struct GS1Code {
    let code: Int
    
    public init(code: Int) {
        self.code = code
    }
    public var description: String? {
        switch code {
        case 000...019:
            return "UPC-A compatible -  United States and  Canada"
        case 020...029:
            return "UPC-A compatible - Used to issue restricted circulation numbers within a geographic region [1]"
        case 030...039:
            return "UPC-A compatible -  United States drugs (see United States National Drug Code)"
        case 040...049:
            return "UPC-A compatible - Used to issue restricted circulation numbers within a company"
        case 050...059:
            return "UPC-A compatible - GS1 US reserved for future use"
        case 060...099:
            return "UPC-A compatible -  United States and  Canada"
        case 100...139:
            return "United States"
        case 200...299:
            return "Used to issue GS1 restricted circulation number within a geographic region[1]"
        case 300...379:
            return "France and  Monaco"
        case 380:
            return "Bulgaria"
        case 383:
            return "Slovenia"
        case 385:
            return "Croatia"
        case 387:
            return "Bosnia and Herzegovina"
        case 389:
            return "Montenegro"
        case 390:
            return "Kosovo"
        case 400...440:
            return "Germany (440 code inherited from former  East Germany upon reunification in 1990)"
        case 450...459:
            return "Japan (new Japanese Article Number range)"
        case 460...469:
            return "Russia (barcodes inherited from the  Soviet Union)"
        case 470:
            return "Kyrgyzstan"
        case 471:
            return "Taiwan"
        case 474:
            return "Estonia"
        case 475:
            return "Latvia"
        case 476:
            return "Azerbaijan"
        case 477:
            return "Lithuania"
        case 478:
            return "Uzbekistan"
        case 479:
            return "Sri Lanka"
        case 480:
            return "Philippines"
        case 481:
            return "Belarus"
        case 482:
            return "Ukraine"
        case 483:
            return "Turkmenistan"
        case 484:
            return "Moldova"
        case 485:
            return "Armenia"
        case 486:
            return "Georgia"
        case 487:
            return "Kazakhstan"
        case 488:
            return "Tajikistan"
        case 489:
            return "Hong Kong"
        case 490...499:
            return "Japan (original Japanese Article Number range)"
        case 500...509:
            return "United Kingdom"
        case 520...521:
            return "Greece"
        case 528:
            return "Lebanon"
        case 529:
            return "Cyprus"
        case 530:
            return "Albania"
        case 531:
            return "North Macedonia"
        case 535:
            return "Malta"
        case 539:
            return "Ireland"
        case 540...549:
            return "Belgium and  Luxembourg"
        case 560:
            return "Portugal"
        case 569:
            return "Iceland"
        case 570...579:
            return "Denmark, Faroe Islands and  Greenland"
        case 590:
            return "Poland"
        case 594:
            return "Romania"
        case 599:
            return "Hungary"
        case 600...601:
            return "South Africa"
        case 603:
            return "Ghana"
        case 604:
            return "Senegal"
        case 608:
            return "Bahrain"
        case 609:
            return "Mauritius"
        case 611:
            return "Morocco"
        case 613:
            return "Algeria"
        case 615:
            return "Nigeria"
        case 616:
            return "Kenya"
        case 617:
            return "Cameroon"
        case 618:
            return "Ivory Coast"
        case 619:
            return "Tunisia"
        case 620:
            return "Tanzania"
        case 621:
            return "Syria"
        case 622:
            return "Egypt"
        case 623:
            return "Brunei"
        case 624:
            return "Libya"
        case 625:
            return "Jordan"
        case 626:
            return "Iran"
        case 627:
            return "Kuwait"
        case 628:
            return "Saudi Arabia"
        case 629:
            return "United Arab Emirates"
        case 630:
            return "Qatar"
        case 631:
            return "Namibia[2]"
        case 640...649:
            return "Finland (sometimes used by Romanian manufacturers)"
        case 690...699:
            return "China"
        case 700...709:
            return "Norway"
        case 729:
            return "Israel"
        case 730...739:
            return "Sweden"
        case 740:
            return "Guatemala"
        case 741:
            return "El Salvador"
        case 742:
            return "Honduras"
        case 743:
            return "Nicaragua"
        case 744:
            return "Costa Rica"
        case 745:
            return "Panama"
        case 746:
            return "Dominican Republic"
        case 750:
            return "Mexico"
        case 754...755:
            return "Canada"
        case 759:
            return "Venezuela"
        case 760...769:
            return "Switzerland and  Liechtenstein"
        case 770...771:
            return "Colombia"
        case 773:
            return "Uruguay"
        case 775:
            return "Peru"
        case 777:
            return "Bolivia"
        case 778...779:
            return "Argentina"
        case 780:
            return "Chile"
        case 784:
            return "Paraguay"
        case 786:
            return "Ecuador"
        case 789...790:
            return "Brazil"
        case 800...839:
            return "Italy,  San Marino and   Vatican City"
        case 840...849:
            return "Spain and  Andorra"
        case 850:
            return "Cuba"
        case 858:
            return "Slovakia"
        case 859:
            return "Czech Republic (barcode inherited from  Czechoslovakia)"
        case 860-506:
            return "Serbia (barcode inherited from  Yugoslavia and  Serbia and Montenegro)"
        case 865:
            return "Mongolia"
        case 867:
            return "North Korea"
        case 868...869:
            return "Turkey"
        case 870...879:
            return "Netherlands"
        case 880:
            return "South Korea"
        case 883:
            return "Myanmar"
        case 884:
            return "Cambodia"
        case 885:
            return "Thailand"
        case 888:
            return "Singapore"
        case 890:
            return "India[3]"
        case 893:
            return "Vietnam"
        case 894:
            return "Bangladesh"
        case 896:
            return "Pakistan"
        case 899:
            return "Indonesia"
        case 900...919:
            return "Austria"
        case 930...939:
            return "Australia"
        case 940...949:
            return "New Zealand"
        case 950:
            return "GS1 Global Office: Special applications"
        case 951:
            return "Used to issue General Manager Numbers for the EPC General Identifier (GID) scheme as defined by the EPC Tag Data Standard"
        case 952:
            return "Used for demonstrations and examples of the GS1 system"
        case 955:
            return "Malaysia"
        case 958:
            return "Macau"
        case 960...961:
            return "GS1 UK Office: GTIN-8 allocations"
        case 962...969:
            return "GS1 Global Office: GTIN-8 allocations"
        case 977:
            return "Serial publications (ISSN)"
        case 978...979:
            return "\"Bookland\" (ISBN) – 979-0 used for sheet music (\"Musicland\", ISMN-13, replaces deprecated ISMN M- numbers)"
        case 980:
            return "Refund receipts"
        case 981...984:
            return "GS1 coupon identification for common currency areas"
        case 990...999:
            return "GS1 coupon identification"
        default:
            return nil
        }
    }
    
}
