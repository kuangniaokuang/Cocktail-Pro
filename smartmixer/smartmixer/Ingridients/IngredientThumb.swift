//
//  FilletCell.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-8-20.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
@IBDesignable class IngredientThumb: UICollectionViewCell {
    
    @IBOutlet var image:UIImageView!
    
    @IBOutlet var name:UILabel!
    
    @IBOutlet var nameEng:UILabel!
    
    @IBOutlet var alcohol:UILabel!
    
    @IBOutlet var collect:UIImageView!
    
    
    //设置窗口的样式
    var selfIngridient:Ingridient!
    func SetContentData(ingridient : Ingridient){
        selfIngridient = ingridient
        name.text = ingridient.name//"龙舌兰 Tequila"
        nameEng.text = ingridient.nameEng
        image.image = UIImage(named: ingridient.thumb)
        alcohol.text = "29°" //ingridient
        if(ingridient.ihave == true){
            collect!.image = UIImage(named: "Heartyes.png")
        }else{
            collect!.image = UIImage(named: "Heartno.png")
        }
    }
    //设置酒器的收藏
    var selfContainer:Container!
    func SetContainer(container:Container){
        selfContainer = container
        name.text = container.name//"龙舌兰 Tequila"
        nameEng.text = container.nameEng
        image.image = UIImage(named: container.thumb)
        if(container.ihave == true){
            collect!.image = UIImage(named: "Heartyes.png")
        }else{
            collect!.image = UIImage(named: "Heartno.png")
        }
    }
    
    //点击收藏与取消收藏
    @IBAction func clickCollect (sender : UIButton)
    {
        if(selfIngridient != nil){
            selfIngridient.ihave = !selfIngridient.ihave.boolValue
            if(selfIngridient.ihave == true){
                collect!.image = UIImage(named: "Heartyes.png")
                UserHome.addHistory(2, id: selfIngridient.id.integerValue, thumb: selfIngridient.thumb, name: selfIngridient.name)
            }else{
                collect!.image = UIImage(named: "Heartno.png")
                UserHome.removeHistory(2, id: selfIngridient.id.integerValue)
            }
        }else{
            selfContainer.ihave = !selfContainer.ihave.boolValue
            if(selfContainer.ihave == true){
                collect!.image = UIImage(named: "Heartyes.png")
                UserHome.addHistory(3, id: selfContainer.id.integerValue, thumb: selfContainer.thumb, name: selfContainer.name)
            }else{
                collect!.image = UIImage(named: "Heartno.png")
                UserHome.removeHistory(3, id: selfContainer.id.integerValue)
            }
        }
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
    }
    
}