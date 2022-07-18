
class MicroAppEvent {
    name = "";
    payload;
    distinct = true;
    channels = [];
    version;
    datetime;

    static fromJson(jsonString){
        var javascriptObject = JSON.parse(jsonString);
        return Object.assign(new MicroAppEvent(), javascriptObject);
    }
}

MicroAppEventControllerDelegate = {
    events: new Map(),
    listen: (channel, callback) => {
        const oldEvents = MicroAppEventControllerDelegate.events.get(channel);
        if (MicroAppEventControllerDelegate.events.has(channel)) {
            return MicroAppEventControllerDelegate.events.set(channel, [ ...oldEvents, callback ]);
        }
        return MicroAppEventControllerDelegate.events.set(channel, [ callback ]);
    },
    emit: (topic, data) => {
        const myListeners = MicroAppEventControllerDelegate.events.get(topic);
        if (Array.isArray(myListeners) && myListeners.length) {
            myListeners.forEach(event => event(data));
        }
    }
}

class MicroAppEventController {

    emit(microAppEventJson) {
        FlutterMicroAppEvent.postMessage(microAppEventJson);
    }
    
    onFlutterMicroAppEvent(microAppEventJson) {

        var microAppEvent = MicroAppEvent.fromJson(microAppEventJson);
        var channels = microAppEvent.channels;

        if (channels != null && channels.length > 0) {
            channels.forEach(channel => {
                this.emitInternal(channel, microAppEvent);
            });
        }

        return MicroAppEventController.handleFlutterMicroAppEvent(microAppEvent);
    }

    listen(channel, callback) {
        return MicroAppEventControllerDelegate.listen(channel, callback);
    }

    emitInternal(channel, microAppEvent) {
        return MicroAppEventControllerDelegate.emit(channel, microAppEvent);
    }

    // This is the method that will be called by the Flutter app
    // and will be used to return a null value as default, to the Flutter app
    // You should overwrite it, if you need to do something else
    static handleFlutterMicroAppEvent(microAppEvent) {
        return null;
    }
}
const FlutterMicroApp = new MicroAppEventController();