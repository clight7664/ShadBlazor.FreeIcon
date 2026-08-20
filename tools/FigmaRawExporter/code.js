figma.showUI(__html__, { width: 420, height: 240 });

function findSectionName(node) {
  let current = node.parent;
  while (current) {
    if (current.type === "SECTION") {
      return current.name;
    }
    current = current.parent;
  }
  return null;
}

figma.ui.onmessage = async (message) => {
  if (message.type !== "export-current-page") {
    return;
  }

  try {
    const components = figma.currentPage.findAllWithCriteria({
      types: ["COMPONENT"]
    });

    const icons = [];

    for (let i = 0; i < components.length; i++) {
      const component = components[i];
      const svg = await component.exportAsync({ format: "SVG_STRING" });

      icons.push({
        id: component.id,
        name: component.name,
        section: findSectionName(component),
        width: component.width,
        height: component.height,
        svg
      });

      if (i % 20 === 0 || i === components.length - 1) {
        figma.ui.postMessage({
          type: "progress",
          current: i + 1,
          total: components.length,
          name: component.name
        });
      }
    }

    const payload = {
      schema: "shadblazor-freeicon-figma-export-v1",
      exportedAtUtc: new Date().toISOString(),
      fileKey: figma.fileKey || null,
      page: {
        id: figma.currentPage.id,
        name: figma.currentPage.name
      },
      iconCount: icons.length,
      icons
    };

    figma.ui.postMessage({
      type: "download",
      fileName: "shadblazor-freeicon-figma-export.json",
      json: JSON.stringify(payload)
    });
  } catch (error) {
    figma.ui.postMessage({
      type: "error",
      message: error instanceof Error ? error.message : String(error)
    });
  }
};
