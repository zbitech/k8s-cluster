

const zbiDb = db.getSiblingDB("zbiRepo");
var collections = zbiDb.getCollectionNames();

if (collections.size == 0) {
    print("creating zbi documents ...");
    var zbi = {"features": {"authentication": "local"}};

    let res = [
        zbiDb.createCollection("users"),
        zbiDb.users.createIndex({"userid": 1, "email": 1}, {unique: true}),

        zbiDb.createCollection("user_policy"),
        zbiDb.user_policy.createIndex({"userid": 1}, {unique: true}),

        zbiDb.createCollection("apikeys"),
        zbiDb.apikeys.createIndex({"key": 1, "userid": 1}, {unique: true}),

        zbiDb.createCollection("apikey_policy"),
        zbiDb.apikey_policy.createIndex({"key": 1}, {unique: true}),

        zbiDb.createCollection("teams"),
        zbiDb.teams.createIndex({"teamid": 1, "owner": 1}, {unique: true}),

        zbiDb.createCollection("team_members"),
        zbiDb.team_members.createIndex({"teamid": 1, "email": 1, "key": 1}, {unique: true}),

        zbiDb.createCollection("projects"),
        zbiDb.projects.createIndex({"name": 1, "owner": 1, "team": 1}, {unique: true}),

        zbiDb.createCollection("instances"),
        zbiDb.instances.createIndex({"project": 1, "name": 1, "type": 1, "owner": 1}, {unique: true}),

        zbiDb.createCollection("project_events"),
        zbiDb.project_events.createIndex({"project": 1, "action": 1, "timestamp": 1, "actor": 1}, {unique: false}),

        zbiDb.createCollection("instance_events"),
        zbiDb.instance_events.createIndex({
            "project": 1,
            "instance": 1,
            "action": 1,
            "timestamp": 1,
            "actor": 1
        }, {unique: false}),

        zbiDb.createCollection("profile_events"),
        zbiDb.profile_events.createIndex({"userid": 1, "action": 1, "timestamp": 1, "actor": 1}, {unique: false}),

        zbiDb.createCollection("team_events"),
        zbiDb.team_events.createIndex({"teamid": 1, "action": 1, "timestamp": 1, "actor": 1}, {unique: false}),

        zbiDb.createCollection("kubernetes_resources"),
        zbiDb.kubernetes_resources.createIndex({"key": 1}, {unique: true}),

        zbiDb.createCollection("project_resources"),
        zbiDb.project_resources.createIndex({"project": 1, "type": 1, "name": 1}, {unique: true}),

        zbiDb.createCollection("instance_resources"),
        zbiDb.instance_resources.createIndex({"project": 1, "instance": 1, "type": 1, "name": 1}, {unique: true}),

        zbiDb.createCollection("snapshots"),
        zbiDb.snapshots.createIndex({"name": 1, "snapshottype": 1, "project": 1, "instance": 1}, {unique: true}),

        zbiDb.createCollection("instance_policy"),
        zbiDb.instance_policy.createIndex({"project": 1, "instance": 1}, {unique: true}),

        zbiDb.createCollection("invitations"),
        zbiDb.invitations.createIndex({"key": 1, "email": 1, "created": 1}, {unique: true})
    ];

    res.push(zbiDb.createCollection("passwords"), zbiDb.passwords.createIndex({"userid": 1}, {unique: true}));

    printjson(res);
    print(zbiDb.getCollectionNames());
} else {
    print("zbi database already created!");
}