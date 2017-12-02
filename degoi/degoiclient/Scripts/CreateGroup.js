var createGroupSearchResult = [];
var createGroupSelectedUser = [];

$(`#create-group-search-input`).on("keypress",
    () => {
        $.ajax({
            type: `get`,
            url: Config.Api + "/api/Chat/CreateGroupSearch?" + $("#search-form").serialize()
        }).done((response) => {
          
            createGroupSearchResult = response;
            displaySearchResult(response);

        }).fail((jqXHR, textStatus, errorThrown) => {
            console.log(jqXHR);
            console.log(textStatus);
            console.log(errorThrown);
            if (fail) fail(jqXHR, textStatus, errorThrown);
        });
    });

function displaySearchResult(list) {
    $("#create-group-search-result-container").empty();
    for (var i = 0; i < list.length; i++) {
   
        var $a = $("<a>", { "class": "list-group-item", "href": `javascript:createGroupAddUserToSelectedUser('${list[i].UserId}')` });
        $a.html(list[i].FullName);
        $("#create-group-search-result-container").append($a);
    }
}

function createGroupAddUserToSelectedUser(userID) {

    for (var i = 0; i < createGroupSelectedUser.length; i++) {
        if (createGroupSelectedUser[i] === userID) {
            createGroupSelectedUser.splice(i,1);
            //remove from list
            $(`#${userID}`).remove();

            return;
        }
    }

    //if not contain in selected list -> insert to list and display in screen

    createGroupSelectedUser.push(userID);
    for (var j = 0; j < createGroupSearchResult.length; j++) {
        if (userID === createGroupSearchResult[j].UserId) {
            var $a = $("<a>",
                {
                    "class": "list-group-item",
                    "id": `${createGroupSearchResult[j].UserId}`,
                    "href": `javascript:createGroupAddUserToSelectedUser('${createGroupSearchResult[j].UserId}')`
                });
            $a.html(createGroupSearchResult[j].FullName);
            $("#create-group-selected-user-container").append($a);
        }
    }
}

$(`#create-group-btn-create`).on("click",
    function() {
        console.log("create-group-btn-create");
        //TODO create Group Room chat

    });