$(function () {
    $(".markdown-body h2, .markdown-body h3").each(function () {
        $(".toctree nav ul").append("<li class='tag-" + this.nodeName.toLowerCase() + "'><a href='#" + $(this).text().toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g, '') + "'>" + $(this).text() + "</a></li>");
        $(this).attr("id", $(this).text().toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g, ''));
        $(".toctree nav ul li:first-child a").parent().addClass("active");
    });

    $(".toctree nav ul li").on("click", "a", function (event) {
        var position = $($(this).attr("href")).offset().top - 190;
        $("html, body").animate({ scrollTop: position }, 400);
        $(".toctree nav ul li a").parent().removeClass("active");
        $(this).parent().addClass("active");
        event.preventDefault();
    });
});
