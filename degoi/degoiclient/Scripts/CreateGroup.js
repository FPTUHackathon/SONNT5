var createGroupSearchResult = [];
var createGroupSelectedUser = [];

$(`#create-group-search-input`).on("input",
    () => {
        if ($(`#create-group-search-input`).val().trim() === "") {
            displaySearchResult([]);
            return;
        }
        degoiapi.searchUser(
            $("#search-form").serialize(),
            (response) => {
                createGroupSearchResult = response;
                displaySearchResult(response);
            }
        );
    });

function displaySearchResult(list) {
    $("#create-group-search-result-container").empty();
    for (var i = 0; i < list.length; i++) {
        if (list[i].UserId == user.UserId) continue;
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

$(`#create-group-btn-create`).on("click", () => {
        var arr = $("#create-group-selected-user-container .list-group-item");
        if (arr.length < 2) return;
        var arrr = [user.UserId];
        for (var i = 0; i < arr.length; i++) arrr.push(arr[i].id);
        var userIds = arrr.sort().join(",");
        var form = $("<form></form>")
            .append($(`<input type='text' name='sUserIds' value='${userIds}'/>`))
            .append($(`<input type='text' name='roomName' value='${$("#roomName").val()}'/>`));
        degoiapi.room($(form).serialize(), (response) => create_popup(response));
        $("#create-group-selected-user-container .list-group-item").remove();
    });

function openCreateGroup() {
    $("#btn-open-group-call").click();
}