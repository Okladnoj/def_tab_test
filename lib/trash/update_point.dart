// void updatePoints() {
//     if (optionsParam.touches.length > 0) {
//       TouchModel touche = optionsParam.touches[0];
//       for (LayerModel layer in optionsParam.layers) {
//         final touchForce = layer.touchForce;
//         for (DynamicPoint point in layer.points) {
//           final _vectorDistanse = distance(dynamicPoint: point, touche: touche);
//           if (touchForce > _vectorDistanse.distance) {
//             final vx = (_vectorDistanse.vx) *
//                 (touchForce - _vectorDistanse.distance) /
//                 10;
//             final vy = (_vectorDistanse.vy) *
//                 (touchForce - _vectorDistanse.distance) /
//                 10;
//             point.vx = vx * touche.force;
//             point.vy = vy * touche.force;
//             point.x += point.vx;
//             point.y += point.vy;
//             point.mvx.waveOne = (point.ox - point.x);
//             point.mvy.waveOne = (point.oy - point.y);
//             point.mvx.waveTwo = 0;
//             point.mvy.waveTwo = 0;
//             point.mvx.waveThree = 0;
//             point.mvy.waveThree = 0;
//             //points.vx
//           } else {
//             double dx = point.ox - point.x;
//             double dy = point.oy - point.y;
//             point.vx = dx * touchForce / 800;
//             point.vy = dy * touchForce / 800;
//             point.x += point.vx;
//             point.y += point.vy;
//           }
//         }
//       }
//     } else {
//       final kof1 = 45;
//       final kof2 = 30;
//       for (LayerModel layer in optionsParam.layers) {
//         for (DynamicPoint point in layer.points) {
//           if (point.mvx.waveThree > 0) {
//             double dx = point.ox - point.x;
//             point.vx = point.mvx.waveThree / kof1;
//             point.x += point.vx;
//             if (point.mvx.waveThree.abs() > dx.abs() / 10) {
//               point.x = point.ox;
//               point.vx = 0;
//               point.mvx.waveThree = 0;
//             }
//           } else if (point.mvx.waveTwo > 0) {
//             double dx = point.ox - point.x;
//             point.vx = point.mvx.waveTwo / kof1;
//             point.x += point.vx;
//             if (point.mvx.waveTwo.abs() < dx.abs()) {
//               point.mvx.waveThree = -point.mvx.waveTwo / 3;
//               point.mvx.waveTwo = 0;
//             }
//           } else if (point.mvx.waveOne > 0) {
//             double dx = point.ox - point.x;
//             point.vx = point.mvx.waveOne / kof2;
//             point.x += point.vx;
//             dx = point.ox - point.x;
//             if (point.mvx.waveOne.abs() < dx.abs()) {
//               point.mvx.waveTwo = -point.mvx.waveOne / 3;
//               point.mvx.waveOne = 0;
//             }
//           } else {
//             double dx = point.ox - point.x;
//             point.vx = dx / 5;
//             point.x += point.vx;
//           }

//           if (point.mvy.waveThree > 0) {
//             double dy = point.oy - point.y;
//             point.vy = point.mvy.waveThree / kof1;
//             point.y += point.vy;
//             if (point.mvy.waveThree.abs() > dy.abs() / 10) {
//               point.y = point.oy;
//               point.vy = 0;
//               point.mvy.waveThree = 0;
//             }
//           } else if (point.mvy.waveTwo > 0) {
//             double dy = point.oy - point.y;
//             point.vy = point.mvy.waveTwo / kof1;
//             point.y += point.vy;
//             if (point.mvy.waveTwo.abs() < dy.abs()) {
//               point.mvy.waveThree = -point.mvy.waveTwo / 3;
//               point.mvy.waveTwo = 0;
//             }
//           } else if (point.mvy.waveOne > 0) {
//             double dy = point.oy - point.y;
//             point.vy = point.mvy.waveOne / kof2;
//             point.y += point.vy;
//             dy = point.oy - point.y;
//             if (point.mvy.waveOne.abs() < dy.abs()) {
//               point.mvy.waveTwo = -point.mvy.waveOne / 3;
//               point.mvy.waveOne = 0;
//             }
//           } else {
//             double dy = point.oy - point.y;
//             point.vy = dy / 5;
//             point.y += point.vy;
//           }
//         }
//       }
//     }
//     for (LayerModel layer in optionsParam.layers) {
//       for (DynamicPoint point in layer.points) {
//         calculateNextPrev(point);
//       }
//     }
//   }
