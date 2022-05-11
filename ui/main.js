addEventListener("message",(e)=>{
    let data = e.data;

    if(data.action == true){
        console.log('2131')

        $("#main-container").fadeIn();
        $("#main-container").html("");
        for(const vehicle of data.vehicleInfo){
            let html = `
            <div data-view=${vehicle.model} class="vehicle">
                <div class="vehicle-name">${vehicle.label}</div>
                <div class="vehicle-price">$${vehicle.normalPrice.toLocaleString()}</div>
                <div class="vehicle-icon" data-model=${vehicle.model} data-model=${vehicle.label} data-price=${vehicle.normalPrice} data-index=${data.index}><i class="fas fa-arrow-circle-right"></i></div>
            </div>
            `
            $("#main-container").append(html);
        }
        $(".vehicle-icon").click(function() {
            let model = $(this).data("model");
            let label = $(this).data("label");
            let price = Number($(this).data("price"));
            let index = $(this).data("index");
            // $("#main-container").fadeOut()
            $.post("http://qb-policegarage/buy",JSON.stringify({model,label,price,index}));
        
        })
        let lastmodel = 0;

        $(".vehicle").click(function() {
            let model = $(this).data("view");
            if(lastmodel != model){
                lastmodel = model
                $.post("http://qb-policegarage/showVeh",JSON.stringify({model}));
            }
        })
    } else if(data.action == "close") {
        console.log('opk')
        $("#main-container").fadeOut()
        $.post("http://qb-policegarage/close",JSON.stringify({}));
    }
})


document.onkeydown = (e) =>{
    let key = e.key;
    if(key == "Escape"){

        $("#main-container").fadeOut()
        $.post("http://qb-policegarage/close",JSON.stringify({}));
    }
}