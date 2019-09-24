import 'dart:math';

import 'package:mp_flutter_chart/chart/mp/core/common_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:mp_flutter_chart/chart/mp/chart/horizontal_bar_chart.dart';
import 'package:mp_flutter_chart/chart/mp/core/data/bar_data.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/description.dart';
import 'package:mp_flutter_chart/chart/mp/core/entry/bar_entry.dart';
import 'package:mp_flutter_chart/chart/mp/core/entry/entry.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_horizontal_alignment.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_flutter_chart/chart/mp/core/highlight/highlight.dart';
import 'package:mp_flutter_chart/chart/mp/core/image_loader.dart';
import 'package:mp_flutter_chart/chart/mp/core/utils/color_utils.dart';
import 'package:mp_flutter_chart/demo/action_state.dart';

class BarChartHorizontal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BarChartHorizontalState();
  }
}

class BarChartHorizontalState
    extends HorizontalBarActionState<BarChartHorizontal>
    implements OnChartValueSelectedListener {
  var random = Random(1);
  int _count = 12;
  double _range = 50.0;

  @override
  void initState() {
    _initBarData(_count, _range);
    super.initState();
  }

  @override
  String getTitle() => "Bar Chart Horizontal";

  @override
  void chartInit() {
    _initBarChart();
  }

  @override
  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 100,
          child: barChart == null ? Center(child: Text("no data")) : barChart,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _count.toDouble(),
                            min: 0,
                            max: 500,
                            onChanged: (value) {
                              _count = value.toInt();
                              _initBarData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "$_count",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _range,
                            min: 0,
                            max: 200,
                            onChanged: (value) {
                              _range = value;
                              _initBarData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "${_range.toInt()}",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void _initBarData(int count, double range) async {
    var img = await ImageLoader.loadImage('assets/img/star.png');
    double barWidth = 9;
    double spaceForBar = 10;
    List<BarEntry> values = List();

    for (int i = 0; i < count; i++) {
      double val = random.nextDouble() * range;
      values.add(BarEntry(x: i * spaceForBar, y: val, icon: img));
    }

    BarDataSet set1;

    set1 = BarDataSet(values, "DataSet 1");

    set1.setDrawIcons(false);

    List<IBarDataSet> dataSets = List();
    dataSets.add(set1);

    barData = BarData(dataSets);
    barData.setValueTextSize(10);
//      data.setValueTypeface(tfLight);
    barData.barWidth = barWidth;

    setState(() {});
  }

  void _initBarChart() {
    if (barData == null) {
      return;
    }

    if (barChart != null) {
      barChart?.data = barData;
      barChart?.getState()?.setStateIfNotDispose();
      return;
    }

    var desc = Description()..enabled = false;
    barChart = HorizontalBarChart(
      barData,
      axisLeftSettingFunction: (axisLeft, chart) {
        axisLeft
          //      ..setTypeface(tf)
          ..drawAxisLine = true
          ..drawGridLines = true
          ..setAxisMinimum(0);
      },
      axisRightSettingFunction: (axisRight, chart) {
        axisRight
          //      ..setTypeface(tf)
          ..drawAxisLine = true
          ..drawGridLines = false
          ..setAxisMinimum(0);
      },
      legendSettingFunction: (legend, chart) {
        legend
          ..verticalAlignment = (LegendVerticalAlignment.BOTTOM)
          ..horizontalAlignment = (LegendHorizontalAlignment.LEFT)
          ..orientation = (LegendOrientation.HORIZONTAL)
          ..drawInside = (false)
          ..formSize = (8)
          ..xEntrySpace = (4);
      },
      xAxisSettingFunction: (xAxis, chart) {
        xAxis
          ..position = XAxisPosition.BOTTOM
//      ..setTypeface(tf)
          ..drawAxisLine = true
          ..drawGridLines = false
          ..setGranularity(10);
      },
      touchEnabled: true,
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: true,
      scaleXEnabled: true,
      scaleYEnabled: true,
      pinchZoomEnabled: false,
      maxVisibleCount: 60,
      description: desc,
      selectionListener: this,
      drawBarShadow: false,
      drawValueAboveBar: false,
      fitBars: true,
    );
    barChart.animator.animateY1(2500);
  }

  @override
  void onNothingSelected() {}

  @override
  void onValueSelected(Entry e, Highlight h) {
//    if (e == null)
//      return;
//
//    RectF bounds = onValueSelectedRectF;
//    chart.getBarBounds((BarEntry) e, bounds);
//    MPPointF position = chart.getPosition(e, AxisDependency.LEFT);
//
//    Log.i("bounds", bounds.toString());
//    Log.i("position", position.toString());
//
//    Log.i("x-index",
//        "low: " + chart.getLowestVisibleX() + ", high: "
//            + chart.getHighestVisibleX());
//
//    MPPointF.recycleInstance(position);
  }
}
