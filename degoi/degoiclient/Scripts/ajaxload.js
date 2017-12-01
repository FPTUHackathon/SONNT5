var ajax = {
    changeUrl: (page, url) => {
        var obj = { Page: page, Url: url };
        history.pushState(obj, obj.Page, obj.Url);
    },
    load: (url) => {
        $("main").empty();
        $.ajax({
            type: "GET",
            url: url,
            dataType: "html",
            success: function (data, textStatus, jqXHR) {
                var bodies = data.split("<main>");
                $("main").html(bodies[bodies.length - 1].split("</main>")[0]);
                ajax.assign();
            }
        });
    },
    assign: () => {
        var as = $("a");
        for (var i = 0; i < as.length; i++) {
            if (as[i].href.indexOf("#") < 0 && as[i].href.indexOf("javascript:") < 0)
                $(as[i]).click((event) => {
                    ajax.changeUrl("title", event.target.href);
                    ajax.load(event.target.href);
                    return false;
                });
        }
    }
}