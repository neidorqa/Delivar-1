import 'package:flutter/material.dart';

void main() => runApp(const DelivarApp());

class DelivarApp extends StatelessWidget {
  const DelivarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DELIVAR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name, shop, category;
  final double price;
  Product(this.name, this.shop, this.category, this.price);
}

final products = [
  Product('Rice 5 kg', 'Fresh Mart', 'Grocery', 320),
  Product('Coconut Oil 1 L', 'Fresh Mart', 'Grocery', 185),
  Product('Milk 1 L', 'Village Dairy', 'Dairy', 62),
  Product('Bread', 'Village Bakery', 'Bakery', 45),
  Product('Eggs 12 pcs', 'Village Dairy', 'Dairy', 95),
  Product('Banana 1 kg', 'Fresh Mart', 'Fruits', 55),
];

class CartPage extends StatefulWidget {
  final List<Product> cart;
  const CartPage({super.key, required this.cart});
  @override
  State<CartPage> createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final total = widget.cart.fold<double>(0, (s,p)=>s+p.price);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: widget.cart.isEmpty
        ? const Center(child: Text('Your cart is empty'))
        : Column(children: [
            Expanded(child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (_,i)=>ListTile(
                title: Text(widget.cart[i].name),
                subtitle: Text(widget.cart[i].shop),
                trailing: Text('₹${widget.cart[i].price.toStringAsFixed(0)}'),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Total', style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
                    Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize:18,fontWeight:FontWeight.bold))]),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: FilledButton(
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>CheckoutPage(total: total))),
                  child: const Text('Proceed to Checkout')))
              ])
            )
          ]),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final double total;
  const CheckoutPage({super.key, required this.total});
  @override State<CheckoutPage> createState()=>_CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {
  final address = TextEditingController(text: 'Enter your house / landmark');
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      const Text('Delivery address', style: TextStyle(fontWeight:FontWeight.bold,fontSize:18)),
      const SizedBox(height:8),
      TextField(controller:address, maxLines:3, decoration: const InputDecoration(border:OutlineInputBorder(), hintText:'House name, place, landmark')),
      const SizedBox(height:20),
      const Text('Payment', style: TextStyle(fontWeight:FontWeight.bold,fontSize:18)),
      const Card(child: ListTile(leading:Icon(Icons.money), title:Text('Cash on Delivery'), trailing:Icon(Icons.check_circle))),
      const Spacer(),
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        const Text('Order total',style:TextStyle(fontWeight:FontWeight.bold)),
        Text('₹${widget.total.toStringAsFixed(0)}',style:const TextStyle(fontWeight:FontWeight.bold))
      ]),
      const SizedBox(height:12),
      SizedBox(width:double.infinity, child:FilledButton(
        onPressed:()=>showDialog(context:context,builder:(_)=>AlertDialog(
          title:const Text('Order placed!'),
          content:const Text('Your DELIVAR order has been placed. You can track it from My Orders.'),
          actions:[TextButton(onPressed:()=>Navigator.popUntil(context,(r)=>r.isFirst),child:const Text('Done'))],
        )), child:const Text('Place Order')))
    ]))
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage> {
  final cart=<Product>[];
  String category='All';
  @override Widget build(BuildContext context) {
    final filtered=category=='All'?products:products.where((p)=>p.category==category).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('DELIVAR', style: TextStyle(fontWeight:FontWeight.w800)),
        actions:[IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CartPage(cart:cart))),icon:Badge(label:Text('${cart.length}'),child:const Icon(Icons.shopping_cart)))]
      ),
      body: ListView(padding:const EdgeInsets.all(16), children:[
        Container(padding:const EdgeInsets.all(18), decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),color:Theme.of(context).colorScheme.primaryContainer),
          child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('Local delivery, made easy.',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold)),
            SizedBox(height:6), Text('Groceries and essentials delivered from shops near you.')
          ])),
        const SizedBox(height:18),
        TextField(decoration:InputDecoration(prefixIcon:const Icon(Icons.search),hintText:'Search products or shops',border:OutlineInputBorder(borderRadius:BorderRadius.circular(14)))),
        const SizedBox(height:18),
        const Text('Categories',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        SizedBox(height:45,child:ListView(scrollDirection:Axis.horizontal,children:['All','Grocery','Dairy','Bakery','Fruits'].map((c)=>Padding(
          padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(c),selected:category==c,onSelected:(_)=>setState(()=>category=c)))).toList())),
        const SizedBox(height:18),
        const Text('Nearby shops',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        const ShopCard(name:'Fresh Mart',subtitle:'Groceries • 1.2 km away'),
        const ShopCard(name:'Village Dairy',subtitle:'Milk & dairy • 1.5 km away'),
        const ShopCard(name:'Village Bakery',subtitle:'Fresh bakery • 1.8 km away'),
        const SizedBox(height:12),
        const Text('Popular products',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        ...filtered.map((p)=>Card(child:ListTile(
          leading:CircleAvatar(child:Text(p.name[0])),
          title:Text(p.name),subtitle:Text('${p.shop} • ${p.category}'),
          trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
            Text('₹${p.price.toStringAsFixed(0)}',style:const TextStyle(fontWeight:FontWeight.bold)),
            InkWell(onTap:(){setState(()=>cart.add(p));ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${p.name} added to cart')));},child:const Text('ADD',style:TextStyle(fontWeight:FontWeight.bold)))
          ]))))
      ])
    );
  }
}

class ShopCard extends StatelessWidget {
  final String name,subtitle;
  const ShopCard({super.key,required this.name,required this.subtitle});
  @override Widget build(BuildContext context)=>Card(child:ListTile(
    leading:const CircleAvatar(child:Icon(Icons.store)),
    title:Text(name,style:const TextStyle(fontWeight:FontWeight.bold)),
    subtitle:Text(subtitle), trailing:const Icon(Icons.chevron_right)));
}
