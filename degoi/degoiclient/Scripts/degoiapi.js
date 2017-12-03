var degoiapi = {
    callApi: (type, url, headers, data, done, fail) => {
        $.ajax({
            type: type,
            url: url,
            headers: headers,
            data: data
        }).done((response) => {
            console.log(response);
            if (done) done(response);
        }).fail((jqXHR, textStatus, errorThrown) => {
            console.log(jqXHR);
            console.log(textStatus);
            console.log(errorThrown);
            if (fail) fail(jqXHR, textStatus, errorThrown);
        });
    },
    login: (data, done, fail) => {
        localStorage.removeItem("token");
        degoiapi.callApi(
            "POST",
            Config.Api + "/Token",
            {},
            data,
            (response) => {
                localStorage.setItem("token", response.access_token);
                document.cookie = `token=${response.access_token} ; expires=${new Date(new Date().getTime() + (365 * 24 * 60 * 60 * 1000)).toUTCString()} ; path=/`;
                if (done) done(response);
            },
            fail
        );
    },
    register: (data, done, fail) => {
        localStorage.removeItem("token");
        degoiapi.callApi(
            "POST",
            Config.Api + "/api/Account/Register",
            {},
            data,
            done,
            fail
        );
    },
    registerExternal: (done, fail) => {
        degoiapi.callApi(
            "POST",
            Config.Api + "/api/Account/RegisterExternal",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            null,
            done,
            fail
        );
    },
    userInfo: (done, fail) => {
        degoiapi.callApi(
            "GET",
            Config.Api + "/api/Account/UserInfo",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            null,
            done,
            fail
        );
    },
    manageInfo: (data, done, fail) => {
        degoiapi.callApi(
            "GET",
            Config.Api + "/api/Account/ManageInfo",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            data,
            done,
            fail
        );
    },
    externalLogins: (data, done, fail) => {
        degoiapi.callApi(
            "GET",
            Config.Api + "/api/Account/ExternalLogins",
            {},
            data,
            done,
            fail
        );
    },
    logout: (done, fail) => {
        degoiapi.callApi(
            "POST",
            Config.Api + "/api/Account/Logout",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            null,
            (response) => {
                localStorage.removeItem("token");
                if (done) done(response);
            },
            fail
        );
    },
    room: (data, done, fail) => {
        degoiapi.callApi(
            "POST",
            Config.Api + "/api/Chat/Room",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            data,
            (response) => {
                if (done) done(response);
            },
            fail
        );
    },
    searchUser: (data, done, fail) => {
        degoiapi.callApi(
            "GET",
            Config.Api + "/api/User/Search",
            {
                Authorization: "Bearer " + localStorage.getItem("token")
            },
            data,
            (response) => {
                if (done) done(response);
            },
            fail
        );
    }
};