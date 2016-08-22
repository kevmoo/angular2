import "package:angular2/src/core/di.dart" show Inject, Injectable;
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;

import "dom_tokens.dart" show DOCUMENT;

@Injectable()
class SharedStylesHost {
  /** @internal */
  List<String> _styles = [];
  /** @internal */
  var _stylesSet = new Set<String>();
  SharedStylesHost() {}
  addStyles(List<String> styles) {
    var additions = <String>[];
    styles.forEach((style) {
      if (!this._stylesSet.contains(style)) {
        this._stylesSet.add(style);
        this._styles.add(style);
        additions.add(style);
      }
    });
    this.onStylesAdded(additions);
  }

  onStylesAdded(List<String> additions) {}
  List<String> getAllStyles() {
    return this._styles;
  }
}

@Injectable()
class DomSharedStylesHost extends SharedStylesHost {
  var _hostNodes = new Set<dynamic>();
  DomSharedStylesHost(@Inject(DOCUMENT) dynamic doc) : super() {
    /* super call moved to initializer */;
    this._hostNodes.add(doc.head);
  }
  /** @internal */
  _addStylesToHost(List<String> styles, dynamic host) {
    for (var i = 0; i < styles.length; i++) {
      var style = styles[i];
      DOM.appendChild(host, DOM.createStyleElement(style));
    }
  }

  addHost(dynamic hostNode) {
    this._addStylesToHost(this._styles, hostNode);
    this._hostNodes.add(hostNode);
  }

  removeHost(dynamic hostNode) {
    _hostNodes.remove(hostNode);
  }

  onStylesAdded(List<String> additions) {
    this._hostNodes.forEach((hostNode) {
      this._addStylesToHost(additions, hostNode);
    });
  }
}
