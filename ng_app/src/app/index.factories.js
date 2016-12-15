(function(){
  'use strict';
  angular.module('ngApp').factory('AuthenticationService',
    ['$base64', '$http', '$cookies', '$timeout',
    function ($base64, $http, $cookies, $timeout) {
        var service = {};
        service.SetCredentials = function (email, password) {
            var authdata = $base64.encode(email + ':' + password);
            $cookies.put('_authdata', authdata);
            $http.defaults.headers.common['Authorization'] = 'Basic ' + authdata;
        };
        service.ClearCredentials = function () {
            $cookies.remove('_authdata');
            $http.defaults.headers.common['Authorization'] = 'Basic ';
        };
        return service;
    }])
})();
